Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB936166CE7
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2020 03:27:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729371AbgBUC1r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Feb 2020 21:27:47 -0500
Received: from mail-bn8nam11on2072.outbound.protection.outlook.com ([40.107.236.72]:6244
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729239AbgBUC1r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Feb 2020 21:27:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fqTAeqapL5r2IzZr00+jilu5gJCOr2B5dwGv8dV0DTfDZRcf+mNn3YD4/p7KyRxiEmhw9oQGxH5HlGb+POlu7FwcQdSgtFN7RqPko25+qHQXnHkdKF7ywsXjhyxnsfmu8RhZDo1Dn4t1P++7+8ukFQ/FPkJuWS5sx/HP7QauKFIo5cCVBqplMpB3ZGXhY1Ydae/hwj4zfnHeiK/cEe0P2/Q+Bvtk2k/yZse4TMJUjmU68LN23IWHocQ8UNwOdJfDBaMR4bhIZw+kPc/7hVbqaWN5BeDqvNKU7PrJIOIbnmNYr5EUq81wwLkXyCfpFfEbhy9AQfTC0o9EPf8Xf86nlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qmYUffdwJvfZb9zlfHtItddsCmdtpHfl4MROZaaodbo=;
 b=MJcu5/Jj+mH40HfjrkNVg46PHq56cuaKTThHKPBRFbD3QhcmZO2/PPgndcCfcS9loFgQosrPpz1rMfMaPcn/8xIzv/hQJVTfiYmAC5SXGIyHEIown0Y82oFykOG7SWOxk1X1D50ZxaozsCxTaKwsILRYCW6Pc61+6b0IBzO5nzR9YQoMq4rSLaMa1LGoON+LXJqUnmaMfJPyeO3Ux4H8HXqaZPPU7qDD3l5KjZ+PNZz+Fkps/4uLg+KWUncwvZ53uecRebvjFpSmkrJIrNsuTlYkO/rHWk+ioXTVLmzOPs3v/KWwQtI0TXYoP+o0x7QpNHZoIzJJOj7dzCZHf0LSKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qmYUffdwJvfZb9zlfHtItddsCmdtpHfl4MROZaaodbo=;
 b=mxwy8Ah1Kr1nW5kXnbY7jc/PeokvH+cdqYiqzWojzyTlVA1bGSyid+zUJYBY7zZWH3wOU6pNNoLbEvO3lQDl91tFOdfLmMTTwaD60lixTXFki5HLmT33alinEI51zOuGohAbqEmPttZBuHNhE3fjCtZTIa1QpmhBqTkbsTwyRDk=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
Received: from DM6PR12MB3865.namprd12.prod.outlook.com (2603:10b6:5:1c4::14)
 by DM6PR12MB3371.namprd12.prod.outlook.com (2603:10b6:5:116::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.22; Fri, 21 Feb
 2020 02:27:44 +0000
Received: from DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::fdd1:4a97:85cc:d302]) by DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::fdd1:4a97:85cc:d302%3]) with mapi id 15.20.2729.033; Fri, 21 Feb 2020
 02:27:43 +0000
Subject: Re: [PATCH v5 14/18] kvm: i8254: Deactivate APICv when using
 in-kernel PIT re-injection mode.
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, joro@8bytes.org, vkuznets@redhat.com,
        rkagan@virtuozzo.com, graf@amazon.com, jschoenh@amazon.de,
        karahmed@amazon.de, rimasluk@amazon.com, jon.grimm@amd.com
References: <1573762520-80328-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1573762520-80328-15-git-send-email-suravee.suthikulpanit@amd.com>
 <20200218115135.4e09ffca@w520.home>
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Message-ID: <24c6a681-df49-6dff-9688-de99faf295c9@amd.com>
Date:   Fri, 21 Feb 2020 09:27:29 +0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.2
In-Reply-To: <20200218115135.4e09ffca@w520.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: KL1PR01CA0043.apcprd01.prod.exchangelabs.com
 (2603:1096:820:1::31) To DM6PR12MB3865.namprd12.prod.outlook.com
 (2603:10b6:5:1c4::14)
MIME-Version: 1.0
Received: from Suravees-MacBook-Pro.local (165.204.80.7) by KL1PR01CA0043.apcprd01.prod.exchangelabs.com (2603:1096:820:1::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.18 via Frontend Transport; Fri, 21 Feb 2020 02:27:39 +0000
X-Originating-IP: [165.204.80.7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1348f071-1fe1-4e63-d963-08d7b675a116
X-MS-TrafficTypeDiagnostic: DM6PR12MB3371:|DM6PR12MB3371:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB337119A5AAFE90B08D72203AF3120@DM6PR12MB3371.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:288;
X-Forefront-PRVS: 0320B28BE1
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39850400004)(346002)(396003)(136003)(376002)(199004)(189003)(31696002)(2616005)(956004)(66556008)(6916009)(86362001)(8676002)(7416002)(16526019)(66946007)(81156014)(81166006)(66476007)(52116002)(316002)(44832011)(53546011)(8936002)(6506007)(36756003)(478600001)(6486002)(26005)(5660300002)(31686004)(6512007)(186003)(45080400002)(6666004)(2906002)(966005)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3371;H:DM6PR12MB3865.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: raHkWBW+oi/Jbd1KGoBAKWq4Wv9jOnpEUpc1m7wHJiKvIKmsmGBn6MzkB/GgTrdE3TlhGDOgV2xrIcqJzbJSmn4via/23GZv0Z1ePneqwqiX5fZfE1fc1sHgwbBbRVCrCx5/oP2gM1MW6TeTiSM1q10mWYMyGDbxeBtl9/+BnMhJRh6Mb6xdfBPlbauO7BvFlLGUqoEeqzyiqS8asya8cJco8TSqhLVLtPRw8Dj1ZxoBnou3t23WW7h8yJrB+l61Isx8+JrffZ9sKFbbAB5BL3ehY+HJ2wiQH9puL/63l4JNH/9vVy58GVrGidHhV1fx5TIJ2P4qGSesFHW/ZwOzXBJ9q6bKl8r9b4IG3GbachIJhDPrM4qxhGpC1qs0H5y1cCvsyzhy8DQXa4RTzDC/TzMdeIhaiG44jS9gYPfcRvKJTXqduw+QBVvrqqxuh/3cCToCMN0N33/+iRChFMDzP36d+Lgg2lIE7jxO/XS5mAbdCAkfOKL8xR2S58ysLbQOEdEVyajsS9CViHVqYvGdpA==
X-MS-Exchange-AntiSpam-MessageData: xQlcmEW2G4V9ZTZZljd7U+SZQ4NDsYqfcAs80L0qarT1bqtkeSGMjchttlzjGaL/KHPEb8TYznGXhww5I5LDN+Gk2wE11S2Pm3hfA8DhMhxdNuXsVM4PzNA5ZlieV7n1pdoHiGTK4i648DmrpXsJVw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1348f071-1fe1-4e63-d963-08d7b675a116
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2020 02:27:43.5297
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I0jIlUaJB2FDaKmrT2GbnhXomqQm3hhoP4t9sjeIoN68g4W2ddfaKo3nKWk/uLSA5PpDzd5hSxe0y3z0vG4FVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3371
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Alex,

On 2/19/20 1:51 AM, Alex Williamson wrote:
> On Thu, 14 Nov 2019 14:15:16 -0600
> Suravee Suthikulpanit <suravee.suthikulpanit@amd.com> wrote:
> 
>> AMD SVM AVIC accelerates EOI write and does not trap. This causes
>> in-kernel PIT re-injection mode to fail since it relies on irq-ack
>> notifier mechanism. So, APICv is activated only when in-kernel PIT
>> is in discard mode e.g. w/ qemu option:
>>
>>    -global kvm-pit.lost_tick_policy=discard
>>
>> Also, introduce APICV_INHIBIT_REASON_PIT_REINJ bit to be used for this
>> reason.
>>
>> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
>> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
>> ---
> 
> Hi,
> 
> I've bisected https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fbugzilla.kernel.org%2Fshow_bug.cgi%3Fid%3D206579&amp;data=02%7C01%7Csuravee.suthikulpanit%40amd.com%7C4d26019120374670e2ec08d7b4a39d9f%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637176487135073269&amp;sdata=Yp1ZSoOxVphXyd60gerlaJkOF67r65emQZ4zhc%2BLFy4%3D&amp;reserved=0 (a
> kernel NULL pointer deref when using device assigned on AMD platforms)
> to this commit, e2ed4078a6ef3ddf4063329298852e24c36d46c8.  My VM is a
> very basic libvirt managed domain with an assigned NIC, I don't even
> have an OS installed:

Thanks for the bisect information. I'm currently working on reproducing this issue. On your system are you enabling AVIC 
(e.g. modprobe kvm_amd avic=1)?

Suravee
