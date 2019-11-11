Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54217F7A17
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2019 18:38:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbfKKRia (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Nov 2019 12:38:30 -0500
Received: from mail-eopbgr820045.outbound.protection.outlook.com ([40.107.82.45]:57152
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726763AbfKKRi2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Nov 2019 12:38:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JmDCo7kEnxQZBpjD8GdkdsZ3i+wI3Q3lyuvWmS9zFFUAMa+j/iEGHm3EmkUpHGy3BtxDxqVmVvs3wpEV6hJyBHpJIoq6ykHodOZSg1wyDkUSFI7L3XgJMLHR8Jc4zU30S9VSS1qc3coKDGZwrdmwa11fjdbhJ3M+A5zVlj3KCFU6TWBK/8YzZxd9sOaIH74ELG6KyjgdkCHa+vkqZ+pAJsnY8H995kF0oY85qJug2MVf1Ift7FtR5V8Gtvoph3b6339VaVZc/jfGM3HdwL1sO4F+xmhmNPEUHarlJTOVyEGR6VBM5TewSQoQRGhOD/5Wh6cpBN/d4HpZ20sVZ2ZuGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZboYDEVDu7mJC++0b/wfsSali1Okmw/KU8KrcZ8ZbQo=;
 b=WCF1HEuI2cRU+fTmkfNIFDcoJgI5vkIrcAMfSzjsDYLpxPWL1vAkzZyANmB0Pe2Xbv7I5pGqRsnReMshUjb35p69a2PqAgyMYp9GLdKlBt+RyR6ZD7vcM3PgPq2iNRhkB0TEF92vd2K7oclY9+OpE5ZgMzGMgk/6QB+tgx6ZdhFneIr36SXvGY38RIyFNVz8f3QfaszQ6ZEwoiR5MUTbjJWz33e2WwGL1gw9Xmw4ITpsC4Bn/TBLMTH1mwnh3bol9KOEfOGMDPsD6VMBBn0mO7+0NC7kbx84gnLCnGpZGB4xTpcdphbwnOWxQsfzCGU54dCqTVkGFDXsi3aNOBcrjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZboYDEVDu7mJC++0b/wfsSali1Okmw/KU8KrcZ8ZbQo=;
 b=rSj1IqJjVJJaFpPQCEjwFtdw6Eg5gUcyCGc8ncoQJOi8nAMujaGe0I8YLIVxvchlbd+HJjchNhHqq2fwIyzQH8wzFtKWWWLyNu1P/JtTvl05kcDMfpqTluFusE6wcn3SdhD2V4wNFT1k8s5QV56VHmWU/RjG7HBtIqL5dRe+LvY=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
Received: from DM6PR12MB3865.namprd12.prod.outlook.com (10.255.173.210) by
 DM6PR12MB3931.namprd12.prod.outlook.com (10.255.174.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.24; Mon, 11 Nov 2019 17:38:25 +0000
Received: from DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862]) by DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862%6]) with mapi id 15.20.2430.027; Mon, 11 Nov 2019
 17:38:25 +0000
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: Re: [PATCH v4 13/17] kvm: i8254: Deactivate APICv when using
 in-kernel PIT re-injection mode.
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "rkagan@virtuozzo.com" <rkagan@virtuozzo.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "graf@amazon.com" <graf@amazon.com>,
        "jschoenh@amazon.de" <jschoenh@amazon.de>,
        "karahmed@amazon.de" <karahmed@amazon.de>,
        "rimasluk@amazon.com" <rimasluk@amazon.com>,
        "Grimm, Jon" <Jon.Grimm@amd.com>
References: <1572648072-84536-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1572648072-84536-14-git-send-email-suravee.suthikulpanit@amd.com>
 <70fb2b49-2198-bde4-a38b-f37bc8bc9847@redhat.com>
 <20191104231712.GD23545@rkaganb.lan>
 <ac4313a6-df96-2223-bed3-33c3a8555c98@redhat.com>
Message-ID: <9361adbc-77e8-4964-c859-8956e1fbb182@amd.com>
Date:   Mon, 11 Nov 2019 11:37:53 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
In-Reply-To: <ac4313a6-df96-2223-bed3-33c3a8555c98@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR16CA0046.namprd16.prod.outlook.com
 (2603:10b6:805:ca::23) To DM6PR12MB3865.namprd12.prod.outlook.com
 (2603:10b6:5:1c8::18)
MIME-Version: 1.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 414015f7-b405-4949-a65a-08d766cdf4ba
X-MS-TrafficTypeDiagnostic: DM6PR12MB3931:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB393138A1301C850870BB4056F3740@DM6PR12MB3931.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0218A015FA
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(136003)(396003)(346002)(376002)(199004)(189003)(316002)(6486002)(110136005)(2201001)(2501003)(11346002)(50466002)(2906002)(446003)(2486003)(23676004)(58126008)(66066001)(8676002)(65956001)(14444005)(81156014)(81166006)(6636002)(52116002)(36756003)(47776003)(65806001)(186003)(8936002)(229853002)(99286004)(6512007)(6116002)(6436002)(76176011)(486006)(3846002)(386003)(478600001)(230700001)(5660300002)(66946007)(2616005)(476003)(26005)(31696002)(44832011)(7416002)(66476007)(66556008)(6246003)(6506007)(14454004)(86362001)(6666004)(31686004)(305945005)(25786009)(53546011)(7736002)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3931;H:DM6PR12MB3865.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8JwT3qtnJSbbV+yqqKXnLQjH6Lpo8/ZfpYKXn8u+p0zm/3/v9W56BMlhP2Usry59z7vqyIZkcsShShZA6g1FODEEcfeCiVwZXgvRKYObM9NKzGJ+HtT+BTn6RM/QTFpcIYMIE6W3fdRlYwZdjpPL8Oa9+SxOnw9s+skK5/EjzJy7+lGzO5aqXW753Rfbo/T1I7b7VrEo3m3cj9rlI11zoOXhdclMmbYRoehmpN7Jg2/ETD+Uibvt22deXwzW01vLurM5Yxq81eHtIR8CLL6lwlYIDLA1edtC0uf1PbjAfZGFfZYyaWXdAo7/Hm/2nqLInuib396hMzmuMN3Hk1H+J2oaklbalrRQJm5vz9VV+OWHl474ZLgt25koyd5zd1VitBWIXjthqLUWI8nEoQ6+H249C4wdbzW5200EOwxWT8hZxbYlxuURIodvbt1G5I+p
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 414015f7-b405-4949-a65a-08d766cdf4ba
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2019 17:38:25.8645
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SFPhlcBxwjFgfaFyfwfXFbvSlba8KePFUOLCduk76EczLVqChwLpyxi20SKaD+Y3Hs/nhe18+NiCGxVGM8c2hQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3931
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Roman/Paolo

On 11/5/2019 4:47 PM, Paolo Bonzini wrote:
> On 05/11/19 00:17, Roman Kagan wrote:
>>> This is not too nice for Intel which does support (through the EOI exit
>>> mask) APICv even if PIT reinjection active.
>> Hmm, it's tempting to just make svm_load_eoi_exitmap() disable AVIC when
>> given a non-empty eoi_exit_bitmap, and enable it back on a clear
>> eoi_exit_bitmap.  This may remove the need to add special treatment to
>> PIT etc.
> 
> That is a very nice idea---we can make that a single disable reason,
> like APICV_DEACTIVATE_REASON_EOI, and Intel can simply never use it.

I took at look at the svm_load_eoi_exitmap() and it is called via:
     kvm_make_scan_ioapic_request() ->
         KVM_REQ_SCAN_IOAPIC -> vcpu_scan_ioapic() ->
             KVM_REQ_LOAD_EOI_EXITMAP -> vcpu_load_eoi_exitmap()

The kvm_make_scan_ioapic_request() is called from multiple places:

arch/x86/kvm/irq_comm.c:
     * kvm_arch_post_irq_routing_update() : Called from kvm_set_irq_routing()

arch/x86/kvm/ioapic.c:
     * kvm_arch_post_irq_ack_notifier_list_update() : (Un)registering irq ack notifier
     * kvm_set_ioapic() : Setting ioapic irqchip
     * ioapic_mmio_write() -> ioapic_write_indirect()

arch/x86/kvm/lapic.c:
     * recalculate_apic_map()

Most calls would be from ioapic_mmio_write()->ioapic_write_indirect().

In case of AMD AVIC, the svm_load_e::vsoi_exitmap() is called several times, and requesting
APICV (de)activate from here when the eoi_exit_bitmap is set/clear would introduce
large overhead especially with SMP machine. So, for now, let's just disable APICv
when in-kernel PIT is in reinject (delay) mode.

I'll also add the logic to avoid unnecessary overhead for Intel.

Thanks,
Suravee
