Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B4D92326C7
	for <lists+kvm@lfdr.de>; Wed, 29 Jul 2020 23:31:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727088AbgG2Vbo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jul 2020 17:31:44 -0400
Received: from mail-eopbgr770059.outbound.protection.outlook.com ([40.107.77.59]:47086
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727079AbgG2Vbn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jul 2020 17:31:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ByRiCPiM3cWkHJzVt+hhZrci/AOC4qO5YlIYWp/Oj4cvwOOrdF2zJJESb1Jzxylv0fqVZ6h82ex6Yjt4/PpIIrHxq2d2/jDBjosmfZYluPn4ZGqAZ5TbxHC5QABZvPSOEPv1Ys+8HDXvNaZhpNfGnPlj1J2KN5UacZuawTmH6jj3Sh+9BaU/g4vNpnbvqlYJj2o4PMuRGcN3QVwpyEBLbjYJusQ+1OSiekpczLQ1zp6LAjkQpDgrH4se15yU/v3Pldo/MWN4Maygm4fxtWSHr3geM5izR0cH0UYgnJ1ohO+KgNPE70fMbE3PNgWQyKIrGYh/jeyf7qPchXds4yAPuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MTUDbuqtf1SXG07aXFhfFF4UJyz/3dgD2hHdztvCdhM=;
 b=Gv1y5l9vwJK656WnjRS6n0WhF4vRORZV428LziO6pJDheCG4fLLKEErBWMqkiKtIywjq4kFaPMbjPAR2Favi/SLPqIsmv2zuVoXniyDnMevGxMJN5YgW1GW2Tmsds1wwfU9CRtX8EMb2v1RGKxliMuzC9z7cUuPMy3sqgu8lkR72HpRQyUeJMMAf6gJ12ZKT/HPtdgySglTolqv/wrGrPknDs2CW0LRzm7Y5mmR3kIV1NSIWLZpM8TtJRnSxZyzlTpEJRfSbN4qjNmTPsojED/JGMecywZn1T6qALwh3EsKZCLfsLpzOwQR1Vg8runYERT1JkG0NPYdY+gyxgl8zBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MTUDbuqtf1SXG07aXFhfFF4UJyz/3dgD2hHdztvCdhM=;
 b=GjBox/W6Wj+kWqtaMtblJ/Mp2ikJGhYY0PEwyDuS5jAAEKq26I/FsrkKQ1yEUUWeYponw3hkgJfq5lYwRe8PAm6ip0jBX6IzooL7KU75p8H/9IEqvbHOQ5isvJ/U/BiCGxoj25eHByy6Thkem4vCeXLx9U1EDR4Ph+EkV9mRXWo=
Authentication-Results: linutronix.de; dkim=none (message not signed)
 header.d=none;linutronix.de; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SA0PR12MB4352.namprd12.prod.outlook.com (2603:10b6:806:9c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.16; Wed, 29 Jul
 2020 21:31:41 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::691c:c75:7cc2:7f2c]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::691c:c75:7cc2:7f2c%6]) with mapi id 15.20.3216.033; Wed, 29 Jul 2020
 21:31:41 +0000
Subject: RE: [PATCH v3 05/11] KVM: SVM: Modify 64 bit intercept field to two
 32 bit vectors
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm list <kvm@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
References: <159597929496.12744.14654593948763926416.stgit@bmoger-ubuntu>
 <159597949971.12744.1782012822260431973.stgit@bmoger-ubuntu>
 <CALMp9eSY4YshSLEThV1KDRmrXG_pcs68OwrgC4cDe4smaVe8Cg@mail.gmail.com>
From:   Babu Moger <babu.moger@amd.com>
Message-ID: <8408a039-13a1-3338-0f06-fb9d5730eeee@amd.com>
Date:   Wed, 29 Jul 2020 16:31:40 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <CALMp9eSY4YshSLEThV1KDRmrXG_pcs68OwrgC4cDe4smaVe8Cg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR01CA0016.prod.exchangelabs.com (2603:10b6:805:b6::29)
 To SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.79] (165.204.77.1) by SN6PR01CA0016.prod.exchangelabs.com (2603:10b6:805:b6::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.17 via Frontend Transport; Wed, 29 Jul 2020 21:31:40 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e758a771-d228-41ba-f3b5-08d83406c89c
X-MS-TrafficTypeDiagnostic: SA0PR12MB4352:
X-Microsoft-Antispam-PRVS: <SA0PR12MB4352DE5774BDA3C59708E7B395700@SA0PR12MB4352.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kLcaNtz84Nh1e/PBG0W0E+FoVDEO+OIUQyH7vfh+h1H/efXw/NwZ6Ga/lwPYRpxw9Oywtf4+oJXcUVL7Umto5Zas/OK//+j8IaBa+Fj692YhUcgGlGgIMOVthtxibm2UD0AiKG5QO9hVY5Y14jUefdsw1EAMkOpeJtz+MzjyhDUrhuiQmFQYqjYDYvJKkv7Pm4DMjuig3UNDh2woMKeQuaq0zOCxWC6EQGUjNCkOQntlGnRW5+cssWCAifjb++V3sS+1Qbbk348EXWOfUpC7RA8meP7f58p+Xja/ZJUenvEjhTSGfj3cb0ZmI1L3t2DZ2tO28O512LtDXCaiaTzdvKWG96cThtInTOx87x2wt7QLFxUpUbIccyuxeGovnzUP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(376002)(39860400002)(346002)(396003)(136003)(6916009)(26005)(52116002)(66946007)(83380400001)(8676002)(2906002)(186003)(16526019)(54906003)(6486002)(31686004)(31696002)(956004)(478600001)(4326008)(5660300002)(86362001)(2616005)(8936002)(44832011)(66476007)(66556008)(7416002)(36756003)(53546011)(16576012)(316002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ToectuKy5DZrTt3DJ7ht/dwlSJYhGt7EXG59XEBa/2bfY1vtEjIeHqZUp3rr4Y4u+XDIoK226sWtDFW4lvM98bOT1pTksVW7wIRk29ZeHWokxmzWBy/6X/zw/EPC36VWHQe9I3sxFrFW+CjQgRG/3nZ2rncI9u0hl8Oi6BpvF9RuHn2jqCqyX+YlpIkHPoW0QSl2fq7D0Z59PFAo0K54fAkPysJ3jqIRnU/ykRb2SSYKSGFmTNzlnkksETmXoDeWxkVTAKwERhrACW24AKRFG/bCvl7EegwOb+y7zI0xPu87uoM4R+nefzGHiC7Ilhu/doHcyrvaQoKwLGxI+l2chd0W3ajosHpFXUuEFWAb8K91Y3iJn12zqFVFiGtvdW0TpqihoBz7QF8DDSdd6pX8JM7Vll1kYokSDPVzHnHZclE/0dnaXMrGD0/Ye0uEma0guzcWZwIhJYLA51bEMR6VlFxEWBhQYsp0lxud9GCNId70HOgQsTlcOPK+p+9cR/vuWFS5vnZ58HVXFRYkpoqoFfXvPPpKv4Kxt0CsL8HdEK8lxjpSfFysHkIMQtoEJIUS1M9tjctFI04zoYSMb5GQ4J1pdJ5MhXa/TMSh5KMoo76ztWvlTXCnzPl5gZHecFB8OhyikXhx6PQ+o162jpV+pw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e758a771-d228-41ba-f3b5-08d83406c89c
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2020 21:31:41.4351
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sCTNP0IDsXX8K7Ana1+Oz6LlNQS1uJCPHq5uZvQX/IpQm84v5CQ7/yWBXZxe4A6N
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4352
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Jim Mattson <jmattson@google.com>
> Sent: Wednesday, July 29, 2020 4:06 PM
> To: Moger, Babu <Babu.Moger@amd.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>; Vitaly Kuznetsov
> <vkuznets@redhat.com>; Wanpeng Li <wanpengli@tencent.com>; Sean
> Christopherson <sean.j.christopherson@intel.com>; kvm list
> <kvm@vger.kernel.org>; Joerg Roedel <joro@8bytes.org>; the arch/x86
> maintainers <x86@kernel.org>; LKML <linux-kernel@vger.kernel.org>; Ingo
> Molnar <mingo@redhat.com>; Borislav Petkov <bp@alien8.de>; H . Peter Anvin
> <hpa@zytor.com>; Thomas Gleixner <tglx@linutronix.de>
> Subject: Re: [PATCH v3 05/11] KVM: SVM: Modify 64 bit intercept field to two 32
> bit vectors
> 
> On Tue, Jul 28, 2020 at 4:38 PM Babu Moger <babu.moger@amd.com> wrote:
> >
> > Convert all the intercepts to one array of 32 bit vectors in
> > vmcb_control_area. This makes it easy for future intercept vector
> > additions.  Also update trace functions.
> >
> > Signed-off-by: Babu Moger <babu.moger@amd.com>
> > ---
> 
> > @@ -128,8 +129,7 @@ enum {
> >
> >  struct __attribute__ ((__packed__)) vmcb_control_area {
> >         u32 intercepts[MAX_VECTORS];
> > -       u64 intercept;
> > -       u8 reserved_1[40];
> > +       u8 reserved_1[60 - (MAX_VECTORS * 4)];
> 
> Perhaps this could be simplified to 'u32 reserved_1[15 - MAX_VECTORS];'

Ok. Will change it. thanks

> 
> >         u16 pause_filter_thresh;
> >         u16 pause_filter_count;
> >         u64 iopm_base_pa;
> 
> Reviewed-by: Jim Mattson <jmattson@google.com>
