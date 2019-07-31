Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 372A27B698
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2019 02:14:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728249AbfGaAOB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Jul 2019 20:14:01 -0400
Received: from mail-eopbgr800115.outbound.protection.outlook.com ([40.107.80.115]:20983
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726210AbfGaAOB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Jul 2019 20:14:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HaK//ynzrov6VJEPzNcUs4KyjELk1JNEH7PVN+FgTVnc84IwUMQjnVLNjrfr6D4z6FRGtf+onXgeATNsaDYaJHiu77E1BH7vIUUoxOey3wXFnISviN+DeLLdFjNtqtlV+M470Hm5H20LnD8OKCKQzl374Ugsox7cLTx4/NyrGmxXmJ65Hdzi1ufHaJEd+0+hXvnLpW22UI68W9FfRQiHM3Bv8f+V5boXA3kCK8g7p4EW9dOkYLnaEIlQQHbrDP8kjeHThmYrB53cqYOLncYJHW0feOSNQt7EoeMvdCSGtHRTlVPnuR2AR+PAynIZElej8qGBD0tGX58soMS2PEEYtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7+qkt2g1PB4yERKLvl3kj4w8iAPpQ6pFCDJAgd1iDx8=;
 b=h55tKpqQSKPz4zX9L4WWqTWLagEEFHcVeL3loQMWvEY46z+bQ/f0wdFs/QzoTG7khWvzpni3LXLldU1qRA+yNfpxgLAr5IlLfn2IZzMAeCYKG8CvcIcAfiWXeS5mjbbZC9WiCAAGLALpRUQHPxt9OX+OqxDJ24zhpPP57HLBaHH3M5uHSRxoawje18naTLbobEFIUVzb/OMVdCniDsrFIEFEvwC1P6+8XtOrKo2wOfzNrV+ci/nkj41Kj/OTbCiP06HQU6OAIAC1kSbe3FOCfa80X2mxqzDDng+/YwNZUlW5MDkqXlPXiD88Xe05WHXNLeT/ZdBnim9g92JORDlnBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7+qkt2g1PB4yERKLvl3kj4w8iAPpQ6pFCDJAgd1iDx8=;
 b=l2L/PE7xCtrKV4xHoOP70MrJo0sAxlPV6A+748sijZcttPRlbN0Vvt3JhUV07uYmIznlzsE7m7r05xz2U87a+DYtt+NS4IiXeO4DR79dJh+O3TrPFey9B9yD+tPWark8gZQoHMt47lsCWYD6osWhltXJWR6pOp0imCdmQz3NPw4=
Received: from MWHPR21MB0784.namprd21.prod.outlook.com (10.173.51.150) by
 MWHPR21MB0288.namprd21.prod.outlook.com (10.173.53.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.2; Wed, 31 Jul 2019 00:13:57 +0000
Received: from MWHPR21MB0784.namprd21.prod.outlook.com
 ([fe80::7de1:e6c1:296:4e82]) by MWHPR21MB0784.namprd21.prod.outlook.com
 ([fe80::7de1:e6c1:296:4e82%5]) with mapi id 15.20.2157.001; Wed, 31 Jul 2019
 00:13:57 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     Nadav Amit <namit@vmware.com>, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>
CC:     "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sasha Levin <sashal@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Juergen Gross <jgross@suse.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>
Subject: RE: [PATCH v3 4/9] x86/mm/tlb: Flush remote and local TLBs
 concurrently
Thread-Topic: [PATCH v3 4/9] x86/mm/tlb: Flush remote and local TLBs
 concurrently
Thread-Index: AQHVPc0tyN8NiFudS0OHFO0tHQVBDqbj7WKw
Date:   Wed, 31 Jul 2019 00:13:57 +0000
Message-ID: <MWHPR21MB07849B8AE6D1C4943B6F06F7D7DF0@MWHPR21MB0784.namprd21.prod.outlook.com>
References: <20190719005837.4150-1-namit@vmware.com>
 <20190719005837.4150-5-namit@vmware.com>
In-Reply-To: <20190719005837.4150-5-namit@vmware.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=mikelley@ntdev.microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-07-31T00:13:55.8711110Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=18386b13-1653-4a41-8c42-2a8ca745b308;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=mikelley@microsoft.com; 
x-originating-ip: [24.22.167.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4136bceb-ab23-4308-66e5-08d7154bfb15
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:MWHPR21MB0288;
x-ms-traffictypediagnostic: MWHPR21MB0288:|MWHPR21MB0288:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR21MB028844C36D7FAD0B1375BD8BD7DF0@MWHPR21MB0288.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 011579F31F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(366004)(39860400002)(346002)(136003)(376002)(199004)(189003)(256004)(22452003)(71190400001)(71200400001)(316002)(66066001)(66556008)(9686003)(53936002)(14444005)(6436002)(7696005)(110136005)(476003)(486006)(478600001)(66446008)(68736007)(76116006)(229853002)(11346002)(76176011)(54906003)(66946007)(66476007)(446003)(33656002)(55016002)(64756008)(10290500003)(186003)(52536014)(102836004)(6116002)(7416002)(3846002)(305945005)(99286004)(7736002)(26005)(4326008)(2906002)(5660300002)(10090500001)(6246003)(8990500004)(6506007)(86362001)(14454004)(8676002)(25786009)(81156014)(74316002)(81166006)(8936002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR21MB0288;H:MWHPR21MB0784.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 7pM4N/3Ak2c/DZOAGoI2OlGmJPZe1oSdhoZpBXNisjOTgAcGdF3O8e+eIhajqjhsE0NY9KUfx5W/iVI49EwHSuqABhxWDG1Kr9bZqXkB2+JCITHuZ+fNuMZ25cIEZHbe0jyVQGn9/V9EF/qQitQlBdtzaOO0BoXcHT+BXhLJs3pyqcCGcnTJxpCdfIEg8rtJvBnEUJqqQtlAhs8Li/5HmRaCt35oCSgY9aGfvck212X1Zur05OVSMLKe7dvfPunMW2kfc+cwhwba9kfGydo2u5Ah+l7KwC7pP4JmKRcmwhFoH3RULLT5v5FpOxreJZLMtBC87MuOUl0QcqDRYY7Rb8yhO+eDY7953WqIP/bO2EIJxeXeTkCx5Iipg38yOlTEXHw3h41sEAX9fYaFBnPsYXcxnrRYpnP7mGHvNOBN+k8=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4136bceb-ab23-4308-66e5-08d7154bfb15
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2019 00:13:57.4299
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uUl+NcMFyy3iOycg7CU2I+3933Yo3iaMJO735J1Vj5VxvRlEmuMyfMxQLd8hgncrZsmrilYj3DL5D2ehRvAWkYnS6LwZwCFdREsqx/h3AlY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR21MB0288
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nadav Amit <namit@vmware.com> Sent: Thursday, July 18, 2019 5:59 PM
>=20
> To improve TLB shootdown performance, flush the remote and local TLBs
> concurrently. Introduce flush_tlb_multi() that does so. Introduce
> paravirtual versions of flush_tlb_multi() for KVM, Xen and hyper-v (Xen
> and hyper-v are only compile-tested).
>=20
> While the updated smp infrastructure is capable of running a function on
> a single local core, it is not optimized for this case. The multiple
> function calls and the indirect branch introduce some overhead, and
> might make local TLB flushes slower than they were before the recent
> changes.
>=20
> Before calling the SMP infrastructure, check if only a local TLB flush
> is needed to restore the lost performance in this common case. This
> requires to check mm_cpumask() one more time, but unless this mask is
> updated very frequently, this should impact performance negatively.
>=20
> Cc: "K. Y. Srinivasan" <kys@microsoft.com>
> Cc: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: Stephen Hemminger <sthemmin@microsoft.com>
> Cc: Sasha Levin <sashal@kernel.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: x86@kernel.org
> Cc: Juergen Gross <jgross@suse.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Andy Lutomirski <luto@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> Cc: linux-hyperv@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: virtualization@lists.linux-foundation.org
> Cc: kvm@vger.kernel.org
> Cc: xen-devel@lists.xenproject.org
> Signed-off-by: Nadav Amit <namit@vmware.com>
> ---
>  arch/x86/hyperv/mmu.c                 | 10 +++---
>  arch/x86/include/asm/paravirt.h       |  6 ++--
>  arch/x86/include/asm/paravirt_types.h |  4 +--
>  arch/x86/include/asm/tlbflush.h       |  8 ++---
>  arch/x86/include/asm/trace/hyperv.h   |  2 +-
>  arch/x86/kernel/kvm.c                 | 11 +++++--
>  arch/x86/kernel/paravirt.c            |  2 +-
>  arch/x86/mm/tlb.c                     | 47 ++++++++++++++++++---------
>  arch/x86/xen/mmu_pv.c                 | 11 +++----
>  include/trace/events/xen.h            |  2 +-
>  10 files changed, 62 insertions(+), 41 deletions(-)
>=20

For the Hyper-V parts --
Reviewed-by: Michael Kelley <mikelley@microsoft.com>

