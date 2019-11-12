Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD60FF8430
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2019 01:08:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727785AbfKLAIM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Nov 2019 19:08:12 -0500
Received: from mail-eopbgr700053.outbound.protection.outlook.com ([40.107.70.53]:24193
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727793AbfKLAIM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Nov 2019 19:08:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FICuulxL66LTwhkLvDjPdmwdzacRVpHa2goUNQMG4ouw5EIKi5qEmntQnfXnzSHUdqFXPCR4nF+kr1c4gR77PJTZo56t2EjwLvqLzYxEaBRNNAYYfttjqbWua1VQwShuzOuXPzQQVhEH7r74PeYY8wSy4CBhKxBPHgHdIhM+roFsZHf3DlLJb53TgiKmWosOWJmCf6qP0Ez72q5butTbcaPzIakiYVnfagpKcSRdkuHKx/qjgvNkvSlhOxwWXwpaa+mv5FyLNAHRcQXJyYIMHlWxHqrnhfMOZyWBKerWZlwF4eepSFx4kKg08qH2WxoQZLEdrU10FkCCwyhVmgA0gA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YxcxT4enKquqOZSfxUBr3KsWiQfpHJVq4MWaHDZHTUE=;
 b=HIvR2bOwojIFdWBuTQtAGVSvAoGM4RW5ILjsaFmywXQ1tMpPfRelWLBNI0wfhUsx1ZsD/wepjV7vTNouv8/Zbvj2gaJNjdwVnKy3NopiVVX8wI6xidqW1NVuT7XjHIj/qIoAOS4UcyLnNnRD2tN6TO67GM5kQOXZT63zzwBLrxKHXVt4iMan9Z8uQS7rzHH8xipUh3OBIObWZl1VrErhaF71wdP5fLPP7/d+lET4k6rSaAfIzup2K/13h9gYeAcST0tO8U9zbOzfD/gUU0VElYHoib95/HUDKocBLMqpRWuVRtwMqXqQq+LV2StqOib5iqfi4zLHlVKb/HDnn2vi5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YxcxT4enKquqOZSfxUBr3KsWiQfpHJVq4MWaHDZHTUE=;
 b=LaKmPHUFfNyMrZdFZDsO4241aiFSZR0jlgAeXGkCxu7r7Yp9+T0PkCYfRXOVFDevwreQ4UTbfqaTCbPnSM8lCMdXJWctmXU//aefW6irAnmrHELwBiI0kfjKNiVFkJenb98PHTwo7XrxEdnSHABtTpAqEbyUMZ0YQPKFfJTbbew=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
Received: from DM6PR12MB3865.namprd12.prod.outlook.com (10.255.173.210) by
 DM6PR12MB3722.namprd12.prod.outlook.com (10.255.172.83) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.23; Tue, 12 Nov 2019 00:08:09 +0000
Received: from DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862]) by DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862%6]) with mapi id 15.20.2430.027; Tue, 12 Nov 2019
 00:08:09 +0000
Subject: Re: [PATCH v4 08/17] kvm: x86: Introduce APICv pre-update hook
To:     "rkagan@virtuozzo.com" <rkagan@virtuozzo.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "graf@amazon.com" <graf@amazon.com>,
        "jschoenh@amazon.de" <jschoenh@amazon.de>,
        "karahmed@amazon.de" <karahmed@amazon.de>,
        "rimasluk@amazon.com" <rimasluk@amazon.com>,
        "Grimm, Jon" <Jon.Grimm@amd.com>
References: <1572648072-84536-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1572648072-84536-9-git-send-email-suravee.suthikulpanit@amd.com>
 <20191104220457.GB23545@rkaganb.lan>
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Message-ID: <a087061a-1217-962f-43ae-1d791c9d38f6@amd.com>
Date:   Mon, 11 Nov 2019 18:08:05 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.1
In-Reply-To: <20191104220457.GB23545@rkaganb.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR08CA0017.namprd08.prod.outlook.com
 (2603:10b6:805:66::30) To DM6PR12MB3865.namprd12.prod.outlook.com
 (2603:10b6:5:1c8::18)
MIME-Version: 1.0
X-Originating-IP: [165.204.77.11]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f3dde5a2-3187-4467-8ff7-08d76704667d
X-MS-TrafficTypeDiagnostic: DM6PR12MB3722:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB3722B41451ED4450E603E81EF3770@DM6PR12MB3722.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 021975AE46
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(376002)(136003)(366004)(39860400002)(346002)(199004)(189003)(478600001)(26005)(230700001)(99286004)(6116002)(3846002)(2486003)(52116002)(50466002)(2906002)(53546011)(6506007)(386003)(76176011)(446003)(36756003)(2616005)(11346002)(476003)(486006)(44832011)(25786009)(2501003)(47776003)(4744005)(66066001)(65956001)(65806001)(14454004)(6666004)(23676004)(5660300002)(6636002)(66556008)(7736002)(8676002)(86362001)(81156014)(31686004)(6512007)(66476007)(229853002)(186003)(66946007)(2201001)(31696002)(6486002)(15650500001)(14444005)(110136005)(58126008)(316002)(7416002)(6436002)(81166006)(6246003)(8936002)(305945005)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3722;H:DM6PR12MB3865.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MoPIKB1SeqI9frViaftfvpHRS+hq5r1p+b2Il+Tm9m+24K+08MC195xNIUPOIANGV8waNZ3wCtCixeQ7Zlo6oZSQpet3xXr0wbvS+wRH2IW82t6qmhMEBmV2MHDYUdac/P8RkCmExWsPAzewQ8TV5hHILi83qMS4u90i7SPwPp+nsVbcS/9qhyM6gQMBy279s1fO3SOzUce74KeXbThMhnDHkdLcmKf3UQq2ZMeqGRCmF1Iusim3ym2TAkqVNJXcUzU4ruwPpZD71UXXVD6Hc2+WWJqUEa61jum32setbjwVkXtnE6Qxn5K2kHsaNrgT2/5hc2IpBEH5zd6YiuBdQxQqFL3udpVDi9r+MLzdrzzO80qwbfTA6mvt0FnbFWgwhmAyF7ygz9xbJLBHlYGi8pBu6fNTG+aB32iJc3B4ycen1HgjENh8D0pdqdA7zs0Z
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3dde5a2-3187-4467-8ff7-08d76704667d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2019 00:08:09.6677
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TWbaMMO8uoCSsTMlLDjEZkp9XH/4Qn7KHGPPsVK1FvFNJ/LgkcCu92H8W6+Lme4FOikef4z1B5MRvD3R9B+KBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3722
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Roman,

On 11/4/19 4:05 PM, Roman Kagan wrote:
> On Fri, Nov 01, 2019 at 10:41:31PM +0000, Suthikulpanit, Suravee wrote:
>> AMD SVM AVIC needs to update APIC backing page mapping before changing
>> APICv mode. Introduce struct kvm_x86_ops.pre_update_apicv_exec_ctrl
>> function hook to be called prior KVM APICv update request to each vcpu.
> This again seems to mix up APIC backing page and APIC access page.
> 
> And I must be missing something obvious, but why is it necessary to
> unmap the APIC access page while AVIC is disabled?  Does keeping it
> around stand in the way when working with AVIC disabled?

I have replied to patch 07/17 with explanation.

Yes, keeping the APIC access page while disabling AVIC would cause
the SVM to not function properly.

Thanks,
Suravee

> Thanks,
> Roman.
> 
