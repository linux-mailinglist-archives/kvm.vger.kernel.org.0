Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44AAD3AA79E
	for <lists+kvm@lfdr.de>; Thu, 17 Jun 2021 01:42:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234735AbhFPXpE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Jun 2021 19:45:04 -0400
Received: from mail-mw2nam08on2079.outbound.protection.outlook.com ([40.107.101.79]:34753
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234597AbhFPXpD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Jun 2021 19:45:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WOpPIHsAtFL0jFQLOzJvOvcFLgua4wdUs+D4gJFPmDSs3W4H5IXUjRl0Dlj3SO1La5RS5Xz/tlZUHv5tTUI1LwQqh7VsrF14U2Jx7cvugsFdUf3uH6tJkqiZhsuJPIKANa//+428K4MmpGNdWeY4EymvuS5Im6n60KKylTUG3LZ/1/5M8kzv05+/pHBCWm0CLYAG7nHqKRSCa7U5KhTDMP464tTetk4SFdXWzcA5MtTfnFJEQlLUVG4pqnInzOe9xEz4salPIbWMBmYQTuszUeHbErGMJ8UrJeEfPVStdoRaPGDWQcSSLpJwSQkp4q7iIsXySjBGaJMz3ixDveEGUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IybMkLY5gUcP/e2LmclHVI4zkRceeZUrtZhKoqsKJpQ=;
 b=GsiwAJwiOIIKQBpTyFHIS+eFxrtRbzyz74JvyUKBu43thdcftiTTIFclHGvZ4M7gsppE8QBH6Rv3HszlSMk5tEdEgrwmKF4/jih7wb1UdyJYsVFYQC4Q3hSeH0VRqJFheeGPoyvl3C6Ot8DbfsxSkBMctCUWdzdQ6XSmB93tf+qgu28pEpnMswdsYelgA1DOr6UmxkwJleVCeFCF+BBV1whV5JduZ6T9MeKqXNeZ/HDo4flAK8PXGrPMx6tIIwApK5LXIzQrrWVFA5x/CdXbBpQp2OFVmXAwPy+6PDd89M6J3JTSCwFOv/vtjhh/HPZZ01EG3hfbA83qnjMjZqK46Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IybMkLY5gUcP/e2LmclHVI4zkRceeZUrtZhKoqsKJpQ=;
 b=mI3BUnE/FAhcErupISxMP+8cw9n1eGA8ENNd1RsFuYDrompAX4+SgaJ2ZmKNx7Q04HjdpA76PRQc/DeTgZyzypvecM/M0pG7OeHvtAUrC5+rLGGbphzJ0hCS/MJ+PgiKTxxg0BA/gRwXRQ8mdlM257GWbHjuux4SZ+n2IRSMLPVP6cPZgmIg4Tat7iznaCIq6wKexLu7HcQmLlO5Vi8g4makbTq8tiQka3z8vzHc7S365kepSPVdYyLAsqetWk4YtaHKFhJnh2FxbHPx/mETyjTdWQ07+kiq9nat1R+Tp4pAylDKXrNPEaa5tTBlr9+vcoKAzV+JjF6XlLR/sQ39WA==
Received: from BN6PR22CA0064.namprd22.prod.outlook.com (2603:10b6:404:ca::26)
 by DM5PR1201MB2553.namprd12.prod.outlook.com (2603:10b6:3:eb::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.18; Wed, 16 Jun
 2021 23:42:55 +0000
Received: from BN8NAM11FT017.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:ca:cafe::14) by BN6PR22CA0064.outlook.office365.com
 (2603:10b6:404:ca::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.16 via Frontend
 Transport; Wed, 16 Jun 2021 23:42:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT017.mail.protection.outlook.com (10.13.177.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4242.16 via Frontend Transport; Wed, 16 Jun 2021 23:42:55 +0000
Received: from [172.27.0.196] (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 16 Jun
 2021 23:42:48 +0000
Subject: Re: [PATCH 09/11] PCI: add matching checks for driver_override
 binding
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>, <cohuck@redhat.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <aviadye@nvidia.com>, <oren@nvidia.com>, <shahafs@nvidia.com>,
        <parav@nvidia.com>, <artemp@nvidia.com>, <kwankhede@nvidia.com>,
        <ACurrid@nvidia.com>, <cjia@nvidia.com>, <yishaih@nvidia.com>,
        <kevin.tian@intel.com>, <hch@infradead.org>, <targupta@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>, <liulongfang@huawei.com>,
        <yan.y.zhao@intel.com>
References: <20210615150458.GR1002214@nvidia.com>
 <20210615102049.71a3c125.alex.williamson@redhat.com>
 <20210615204216.GY1002214@nvidia.com>
 <20210615155900.51f09c15.alex.williamson@redhat.com>
 <20210615230017.GZ1002214@nvidia.com>
 <20210615172242.4b2be854.alex.williamson@redhat.com>
 <20210615233257.GB1002214@nvidia.com>
 <20210615182245.54944509.alex.williamson@redhat.com>
 <20210616003417.GH1002214@nvidia.com>
 <cd95b92c-a23b-03a7-1dd3-9554b9d22955@nvidia.com>
 <20210616233317.GR1002214@nvidia.com>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <f6ef5c0c-0a85-30ca-5711-3b86d71c141a@nvidia.com>
Date:   Thu, 17 Jun 2021 02:42:46 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210616233317.GR1002214@nvidia.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1deb4bb2-d99c-455b-5b8c-08d9312076d6
X-MS-TrafficTypeDiagnostic: DM5PR1201MB2553:
X-Microsoft-Antispam-PRVS: <DM5PR1201MB2553405B48577850726B1652DE0F9@DM5PR1201MB2553.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +Nl2qaWAgzhXyRwUHGVKtE0jAsgd0ymbQ/CjIYIK9EEiEb8wkcnjtF6roKUPpm3jpZ3TsNqCM64XalmZAqeOE/r6byD36olW+PWhd6xdMKJwD02cUt6M3mb9jm5nw38bFqP+sP6Qp/iARrpl54WaTe9UDAWSjLsPZs3e7TmJVhmoDiZXQkdqaz8vKh7wRulqf8bYEolFc6eowubuNmLXC+QbDFr7dAk64FStWWWZkuMxZhZg07d2yiT0E7TtMg7ZExXcJ+wBFCk4VVrz/OHl5l2xBcmvRJpcFQUpFQWMNZGNkyyqJqnp/VO96XQCvl6lsHctYrDVOhBiR6GuDF+o5U69mGpEGKDUrnq8LwoqL6D4E2+6RtXbbsev6MHvW17fXkIBp+GBkTE5ZJzUWjSuOeeRgyKFilP1lmiTy16an8k8IOKq9b1uF8UYbljZPUz3k2Q4jfi4EFVVuIl1M+gtBMWfmeURJ9RJoSD0du00FFsmV2MbttUyn/g62wYf9xFKmsHqOtCuHuHhvsMEbYIW2JLRJVXQZhUCvKy5drYiQaxKC2+fhmc9BAXSa8HVV6+7UR9EaWoU7kZj2P7mXTgxg0SRnDBfF0kCLSiBSNyY6qTr1jXS/KFhVqZ+gPeg6VsttsqPRi6xGmTPLlN/AA5uKE3871Dv+g7E6AkRtBPh4XePEtcvaSdc71+Z87t+IyMY
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(396003)(39860400002)(136003)(346002)(46966006)(36840700001)(2616005)(26005)(37006003)(31696002)(47076005)(82740400003)(36756003)(316002)(5660300002)(7636003)(53546011)(70206006)(36906005)(426003)(478600001)(36860700001)(6636002)(356005)(16576012)(31686004)(8676002)(8936002)(82310400003)(2906002)(4326008)(336012)(186003)(6862004)(70586007)(86362001)(16526019)(54906003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2021 23:42:55.0460
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1deb4bb2-d99c-455b-5b8c-08d9312076d6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT017.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB2553
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/17/2021 2:33 AM, Jason Gunthorpe wrote:
> On Thu, Jun 17, 2021 at 02:28:36AM +0300, Max Gurtovoy wrote:
>> On 6/16/2021 3:34 AM, Jason Gunthorpe wrote:
>>> On Tue, Jun 15, 2021 at 06:22:45PM -0600, Alex Williamson wrote:
>>>> On Tue, 15 Jun 2021 20:32:57 -0300
>>>> Jason Gunthorpe <jgg@nvidia.com> wrote:
>>>>
>>>>> On Tue, Jun 15, 2021 at 05:22:42PM -0600, Alex Williamson wrote:
>>>>>
>>>>>>>> b) alone is a functional, runtime difference.
>>>>>>> I would state b) differently:
>>>>>>>
>>>>>>> b) Ignore the driver-override-only match entries in the ID table.
>>>>>> No, pci_match_device() returns NULL if a match is found that is marked
>>>>>> driver-override-only and a driver_override is not specified.  That's
>>>>>> the same as no match at all.  We don't then go on to search past that
>>>>>> match in the table, we fail to bind the driver.  That's effectively an
>>>>>> anti-match when there's no driver_override on the device.
>>>>> anti-match isn't the intention. The deployment will have match tables
>>>>> where all entires are either flags=0 or are driver-override-only.
>>>> I'd expect pci-pf-stub to have one of each, an any-id with
>>>> override-only flag and the one device ID currently in the table with
>>>> no flag.
>>> Oh Hum. Actually I think this shows the anti-match behavior is
>>> actually a bug.. :(
>>>
>>> For something like pci_pf_stub_whitelist, if we add a
>>> driver_override-only using the PCI any id then it effectively disables
>>> new_id completely because the match search will alway find the
>>> driver_override match first and stop searching. There is no chance to
>>> see things new_id adds.
>> Actually the dynamic table is the first table the driver search. So new_id
>> works exactly the same AFAIU.
> Oh, even better, so it isn't really an issue
>
>> But you're right for static mixed table (I assumed that this will never
>> happen I guess).
> Me too, we could organize the driver-overrides to be last

Yes we could, but in 2 years from now I'll forget this rule :)

And others may not be aware of it.

>   
>> -       found_id = pci_match_id(drv->id_table, dev);
>> -       if (found_id) {
>> +       ids = drv->id_table;
>> +       while ((found_id = pci_match_id(ids, dev))) {
> Yeah, keep searching makes logical sense to me
>
>> diff --git a/drivers/pci/pci-pf-stub.c b/drivers/pci/pci-pf-stub.c
>> index 45855a5e9fca..49544ba9a7af 100644
>> +++ b/drivers/pci/pci-pf-stub.c
>> @@ -19,6 +19,7 @@
>>    */
>>   static const struct pci_device_id pci_pf_stub_whitelist[] = {
>>          { PCI_VDEVICE(AMAZON, 0x0053) },
>> +       { PCI_DEVICE_FLAGS(PCI_ANY_ID, PCI_ANY_ID,
>> PCI_ID_F_STUB_DRIVER_OVERRIDE) }, /* match all by default (override) */
>>          /* required last entry */
>>          { 0 }
> And we don't really want this change any more right? No reason to put
> pci_stub in the module.alias file?

I actually did it in the patches I attached earlier.

It will look like:

stub_pci:v*d*sv*sd*bc*sc*i*

pci:v00001D0Fd00000053sv*sd*bc*sc*i*

I think it's good practice to avoid matching automatically and auto 
loading any_id_override and vfio_override drivers in general.

Do you see a reason not adding this alias for stub drivers but adding it 
to vfio_pci drivers ?

>
> Thanks,
> Jason
