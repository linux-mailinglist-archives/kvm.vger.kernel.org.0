Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B75DD3B6953
	for <lists+kvm@lfdr.de>; Mon, 28 Jun 2021 21:52:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237102AbhF1Tye (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Jun 2021 15:54:34 -0400
Received: from mail-dm6nam10on2057.outbound.protection.outlook.com ([40.107.93.57]:36064
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233293AbhF1Tye (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Jun 2021 15:54:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Duez9dUF2VNE73MSJTmjHYtCMKi32qGPA6b+yX5KylMHI183s+ypbfBwvFj7PWmWPnZx70PKSM+jpJeLEEAR5Rds2E7MRYwug/pHew9yQfb2v12yPHQDUCJ1LfJwV3BhqxULyNVw074WxnQIwy9pvdzkJjPOlMGdouAQEec3567OtYz/ecyxss51vrb9mg8gh4mgvIethOztMDSGhFltl3kj8s9cGShG/dCNLxbmX9lTSUwpbc6jw9rN2RmLP+PubISUhdeogheBdME6Qw6HBkK/ghLuxmzyluj9eOmQoipn2fhIyz1T7VY1CrVSdZNLrc83LOHBeifZ6RcFTN9mjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NVqaF4NutzG1I9tNaKP7OeDy3ybbHYWA1TkJvMTN0m8=;
 b=GGKyMrQnly+KIXguh1yC8OrgZdi+2jgedUAcmr8Q4kWMxcBpbqhge168OiY746MZuvtUxyr8fvBdv4T1f0BTApHSRvVZ3cKEPJjowtFkOh41/wdiN3sLrO9omKO8/E2Cw3zZFa0aWdGl0k4jGR5FlRZbO0HVwXKk5L+v8UXB1YfF/FqI2R+SQsCBH/UUh0bF5RTEkBmmEjW/PMY2/HW+/urz7nmrd+bixwbMHCyJf6y5wijVJ+yf5k8ntkPY0q4GA9SF2rJYpJbLNYZlxFtL4697XzzrUHYhu6ywnajzw2BS8fICQb9sgvxQAc658Z+rGB2qHxeumn1WNjDS3vuAcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NVqaF4NutzG1I9tNaKP7OeDy3ybbHYWA1TkJvMTN0m8=;
 b=FMT5PrkPyewZXM5smpi3bufH9Wtjb/IxFfrShd9BUEiLnbFckMZAB5YjeHYZyn7Qp8TcjhKRS7Gbffgl0w29uxwdGJdQzCXClRLj5fiUYCiHAGi/0JQjvzyxSyXc7AK+JRuaJ6QmoPtnfGBTfsFhCtAmccgMbMoRh4nRl722QjwgWcfBU9S4SBCVYu0Rfi0tox38fF+adFYAmJP1Q1IZi0J6vOKttCVq83R6PupuiwEP3+/u8rnu1+L5hTn+I3a497Mx2oaQoT+OdrNtMRT5Lz19JC+v21YviGTly8fnu4SFzyrwyfvw2fgdoo1KLLRf0j4qWf8nxRvHtoUwd9Aw4g==
Received: from CO1PR15CA0057.namprd15.prod.outlook.com (2603:10b6:101:1f::25)
 by DM4PR12MB5248.namprd12.prod.outlook.com (2603:10b6:5:39c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.20; Mon, 28 Jun
 2021 19:52:07 +0000
Received: from CO1NAM11FT014.eop-nam11.prod.protection.outlook.com
 (2603:10b6:101:1f:cafe::99) by CO1PR15CA0057.outlook.office365.com
 (2603:10b6:101:1f::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18 via Frontend
 Transport; Mon, 28 Jun 2021 19:52:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT014.mail.protection.outlook.com (10.13.175.99) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4264.18 via Frontend Transport; Mon, 28 Jun 2021 19:52:06 +0000
Received: from [10.40.101.220] (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 28 Jun
 2021 19:52:04 +0000
Subject: Re: [PATCH] vfio/mtty: Enforce available_instances
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <cohuck@redhat.com>, <jgg@nvidia.com>
References: <162465624894.3338367.12935940647049917981.stgit@omen>
 <ee949a98-6998-2032-eb17-00ef8b8d911c@nvidia.com>
 <20210628125602.5b07388e.alex.williamson@redhat.com>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
Message-ID: <641a865f-a45b-10ed-8287-3759191a9686@nvidia.com>
Date:   Tue, 29 Jun 2021 01:22:00 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210628125602.5b07388e.alex.williamson@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a65ff0a6-836c-4b21-30a6-08d93a6e3598
X-MS-TrafficTypeDiagnostic: DM4PR12MB5248:
X-Microsoft-Antispam-PRVS: <DM4PR12MB5248A45806298A77C319458EDC039@DM4PR12MB5248.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +pn5LNXm+w1iLyU4Xq3iaPpHz6t1+Bf8OcUoT6qyq5UdvMKl7j/DNFU32ptIQE7KCSxqTpOnx+wtNl27kErdGwontAdaN4YeNbsp+869GeFI9X0BhSX94rasRwnEC8QLho40kNF1/dwUGzPlFy+ZMTyObOX/6NIWkFOf+78sn3z2JC2jtTqXFh5yyGNCuVvd5CBLZYmHD+4wYnRAthw7sagx/FO6W8YXnkfltwg1st5aD5PU/QCPJBLEklT7rFOkI/TC0xxZAA+c+3Kaa32cOgyGzr1RbDXl4jV37GBleFOCNW8rq4Tx3ChIRay+Mr9GMHQLFnmi4eFuczNLH2EdOmfE461SeqvAGCi10qg1hP3Fe0ZU9hGcEtwEQafE2JIH+tP0IfDklfIoEvpoRJHesddIShyBM9TlHq2uWqmCzSCl3841/0AxS/WELH295xZA9JwCTU+c6J9c1Wm+4wVKHEF/pTbsrcDL0RVnFQ6UQ9ngjSiRXBX0d5q8Tksgn9gOUfv3Z8ZzrhK7KaZjEQ41tTnE/mdMfwDgiArXjKSEmBqYwFs1iewaKfsqkC5c6YV3cTOAIyTD1B9ERnnjLilWC75AvDNr1KUPiv5hFz7p3CwfoQQeFThl90zi/yfQH4F6ktVwd7eXNjPApkEWUGYZPK9axUBW06rbR263DieMmtpW9m/ZvUJ4LdD15ppGgRQe/vZbJJnQxxUtdooomJvY9b+zDzQJWJjMIpxs35NfzChWekz41c2mLDem7ssf+nHBsG2y/5tixkNSz/fCQHuiSpHVovcn6PAQ/KdTkDT6Yc51fWwqMwXpVDtScC2xgO/90tecHtRWdQoIxIea3SSbti8ZCSB1pz+IJHhTT/i2Ydk1GktvDOBWRKa7pQGuzaIOHV+z8VRMonCV88yQGJxL6Q==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(39860400002)(376002)(136003)(346002)(46966006)(36840700001)(356005)(7636003)(83380400001)(8676002)(31686004)(8936002)(82310400003)(36756003)(86362001)(36860700001)(70206006)(31696002)(82740400003)(47076005)(6666004)(2616005)(426003)(54906003)(316002)(16576012)(26005)(186003)(70586007)(6916009)(16526019)(107886003)(5660300002)(478600001)(53546011)(336012)(2906002)(4326008)(131093003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2021 19:52:06.8456
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a65ff0a6-836c-4b21-30a6-08d93a6e3598
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT014.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5248
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/29/2021 12:26 AM, Alex Williamson wrote:
> On Mon, 28 Jun 2021 23:19:54 +0530
> Kirti Wankhede <kwankhede@nvidia.com> wrote:
> 
>> On 6/26/2021 2:56 AM, Alex Williamson wrote:
>>> The sample mtty mdev driver doesn't actually enforce the number of
>>> device instances it claims are available.  Implement this properly.
>>>
>>> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
>>> ---
>>>
>>> Applies to vfio next branch + Jason's atomic conversion
>>>    
>>
>>
>> Does this need to be on top of Jason's patch?
> 
> Yes, see immediately above.
> 
>> Patch to use mdev_used_ports is reverted here, can it be changed from
>> mdev_devices_list to mdev_avail_ports atomic variable?
> 
> It doesn't revert Jason's change, it builds on it.  The patches could
> we squashed, but there's no bug in Jason's patch that we're trying to
> avoid exposing, so I don't see why we'd do that.
>

'Squashed' is the correct word that 'revert', my bad.

>> Change here to use atomic variable looks good to me.
>>
>> Reviewed by: Kirti Wankhede <kwankhede@nvidia.com>
> 
> Thanks!  It was Jason's patch[1] that converted to use an atomic
> though, so I'm slightly confused if this R-b is for the patch below,
> Jason's patch, or both.  Thanks,

I liked 'mdev_avail_ports' approach than 'mdev_used_ports' approach 
here. This R-b is for below patch.

Thanks,
Kirti

> 
> Alex
> 
> [1]https://lore.kernel.org/kvm/0-v1-0bc56b362ca7+62-mtty_used_ports_jgg@nvidia.com/
> 
>>>    samples/vfio-mdev/mtty.c |   22 ++++++++++++++++------
>>>    1 file changed, 16 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c
>>> index ffbaf07a17ea..8b26fecc4afe 100644
>>> --- a/samples/vfio-mdev/mtty.c
>>> +++ b/samples/vfio-mdev/mtty.c
>>> @@ -144,7 +144,7 @@ struct mdev_state {
>>>    	int nr_ports;
>>>    };
>>>    
>>> -static atomic_t mdev_used_ports;
>>> +static atomic_t mdev_avail_ports = ATOMIC_INIT(MAX_MTTYS);
>>>    
>>>    static const struct file_operations vd_fops = {
>>>    	.owner          = THIS_MODULE,
>>> @@ -707,11 +707,20 @@ static int mtty_probe(struct mdev_device *mdev)
>>>    {
>>>    	struct mdev_state *mdev_state;
>>>    	int nr_ports = mdev_get_type_group_id(mdev) + 1;
>>> +	int avail_ports = atomic_read(&mdev_avail_ports);
>>>    	int ret;
>>>    
>>> +	do {
>>> +		if (avail_ports < nr_ports)
>>> +			return -ENOSPC;
>>> +	} while (!atomic_try_cmpxchg(&mdev_avail_ports,
>>> +				     &avail_ports, avail_ports - nr_ports));
>>> +
>>>    	mdev_state = kzalloc(sizeof(struct mdev_state), GFP_KERNEL);
>>> -	if (mdev_state == NULL)
>>> +	if (mdev_state == NULL) {
>>> +		atomic_add(nr_ports, &mdev_avail_ports);
>>>    		return -ENOMEM;
>>> +	}
>>>    
>>>    	vfio_init_group_dev(&mdev_state->vdev, &mdev->dev, &mtty_dev_ops);
>>>    
>>> @@ -724,6 +733,7 @@ static int mtty_probe(struct mdev_device *mdev)
>>>    
>>>    	if (mdev_state->vconfig == NULL) {
>>>    		kfree(mdev_state);
>>> +		atomic_add(nr_ports, &mdev_avail_ports);
>>>    		return -ENOMEM;
>>>    	}
>>>    
>>> @@ -735,9 +745,9 @@ static int mtty_probe(struct mdev_device *mdev)
>>>    	ret = vfio_register_group_dev(&mdev_state->vdev);
>>>    	if (ret) {
>>>    		kfree(mdev_state);
>>> +		atomic_add(nr_ports, &mdev_avail_ports);
>>>    		return ret;
>>>    	}
>>> -	atomic_add(mdev_state->nr_ports, &mdev_used_ports);
>>>    
>>>    	dev_set_drvdata(&mdev->dev, mdev_state);
>>>    	return 0;
>>> @@ -746,12 +756,13 @@ static int mtty_probe(struct mdev_device *mdev)
>>>    static void mtty_remove(struct mdev_device *mdev)
>>>    {
>>>    	struct mdev_state *mdev_state = dev_get_drvdata(&mdev->dev);
>>> +	int nr_ports = mdev_state->nr_ports;
>>>    
>>> -	atomic_sub(mdev_state->nr_ports, &mdev_used_ports);
>>>    	vfio_unregister_group_dev(&mdev_state->vdev);
>>>    
>>>    	kfree(mdev_state->vconfig);
>>>    	kfree(mdev_state);
>>> +	atomic_add(nr_ports, &mdev_avail_ports);
>>>    }
>>>    
>>>    static int mtty_reset(struct mdev_state *mdev_state)
>>> @@ -1271,8 +1282,7 @@ static ssize_t available_instances_show(struct mdev_type *mtype,
>>>    {
>>>    	unsigned int ports = mtype_get_type_group_id(mtype) + 1;
>>>    
>>> -	return sprintf(buf, "%d\n",
>>> -		       (MAX_MTTYS - atomic_read(&mdev_used_ports)) / ports);
>>> +	return sprintf(buf, "%d\n", atomic_read(&mdev_avail_ports) / ports);
>>>    }
>>>    
>>>    static MDEV_TYPE_ATTR_RO(available_instances);
>>>
>>>    
>>
> 
