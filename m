Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5937CCB0F2
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2019 23:18:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732767AbfJCVSD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Oct 2019 17:18:03 -0400
Received: from mail-eopbgr810089.outbound.protection.outlook.com ([40.107.81.89]:24420
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732586AbfJCVRv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Oct 2019 17:17:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UUeabHilvObj5H1B2cn34+CqwuoW/c8Xmf90pI9Xx0UV2yJcBTP6OdBPg6/huqcFWiaKjXu0STsxhbN36gyNpleR5avozeHd/N93eXSNhCr+wT6IuwzoE/CTfyDBpzy842cVG/94bOf3huxcx2n0kMzHoUqnfMN44hqAdqVkk7ljE4WItKH01eIQ0YyQ394jt8GIuiCpB9zaAsXBU546MbV/wdzUcOqmxVs39D/i89qNGarvVrA4L2PVOtBwTh34kJx10WFAeWYwO8e9J5clkMyPxeDjOynS2e0iBCViqhr80PcGI77FqrRaroGV/SIrAwCzscI3fC+T4FBZIsdj1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bKQ/yq6ZW8h+9ow7ZVEAoIjKY6GFVIc36Ic1VgCxzeI=;
 b=n91ie/v0zpit3kY5EmuP5tToldu0uvx292DXZGUDD9Cm54SL2wBuaUOEevpqkt+t8b3RcEJtW2suynD2V68mmopC2GhUkSrlleYTV828uMzkKpAGOS25lZKzjIdXu+4Uygzu5+rPUhoL52ZK7jvvFeqUh1vj7cPy90MQGlp8AmG4OFsNRc0NcM412hPf4NVPttZXd7jIz7L4C/h4n1BlsFB0suIkewKKVDPYKtgUUYzKsPke6fVmUfIYw3Vx3lb9QeD44yfgc3ceCTmSFyj2qzokCpeRxwK2O6S8C8Dz4T4eelJSjhRVMzA93Sa99hXtkN8I9tkFpo46NVrdLQ2tZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bKQ/yq6ZW8h+9ow7ZVEAoIjKY6GFVIc36Ic1VgCxzeI=;
 b=sXUcgtQtTS+FrLd2l+vvkK/amo3jdBHm3NvdyyKH8X/q3NnuJ2F0tRy8fcMj2GJpEPBCQsz4aa0FvhDCs03oR7pnevfSJB0FzMtAwce9w3uyv/pzDhJBlCle/yOTLoVE53lpWxggc97up8dxrdSy2vDuXFt0drLrOS2dStQnrvY=
Received: from DM6PR12MB3163.namprd12.prod.outlook.com (20.179.104.150) by
 DM6PR12MB3115.namprd12.prod.outlook.com (20.178.31.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.20; Thu, 3 Oct 2019 21:17:47 +0000
Received: from DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::85b7:7456:1a67:78aa]) by DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::85b7:7456:1a67:78aa%7]) with mapi id 15.20.2305.023; Thu, 3 Oct 2019
 21:17:47 +0000
From:   "Lendacky, Thomas" <Thomas.Lendacky@amd.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        =?iso-8859-2?Q?Radim_Kr=E8m=E1=F8?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        David Rientjes <rientjes@google.com>
Subject: [PATCH 4/5] KVM: SVM: Convert DEACTIVATE mutex to read/write
 semaphore
Thread-Topic: [PATCH 4/5] KVM: SVM: Convert DEACTIVATE mutex to read/write
 semaphore
Thread-Index: AQHVejAB/rHeFE4CtEK2sFRC1yAFBA==
Date:   Thu, 3 Oct 2019 21:17:47 +0000
Message-ID: <d6c131bd5e43138cdb5c0be98005ffbc582ca833.1570137447.git.thomas.lendacky@amd.com>
References: <cover.1570137447.git.thomas.lendacky@amd.com>
In-Reply-To: <cover.1570137447.git.thomas.lendacky@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.17.1
x-clientproxiedby: SN6PR05CA0006.namprd05.prod.outlook.com
 (2603:10b6:805:de::19) To DM6PR12MB3163.namprd12.prod.outlook.com
 (2603:10b6:5:182::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Thomas.Lendacky@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.78.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 205510b0-9e32-4f6d-45f7-08d748472382
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: DM6PR12MB3115:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB31152C2CABC13A6BA990850AEC9F0@DM6PR12MB3115.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-forefront-prvs: 01792087B6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(396003)(376002)(346002)(136003)(189003)(199004)(26005)(256004)(14444005)(186003)(2906002)(102836004)(6512007)(99286004)(66946007)(476003)(14454004)(6436002)(446003)(8676002)(81166006)(8936002)(81156014)(478600001)(2501003)(11346002)(50226002)(71190400001)(71200400001)(36756003)(6116002)(76176011)(52116002)(86362001)(3846002)(486006)(386003)(6506007)(7736002)(316002)(25786009)(305945005)(5660300002)(7416002)(118296001)(66556008)(66446008)(64756008)(66476007)(4326008)(54906003)(110136005)(6486002)(66066001)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3115;H:DM6PR12MB3163.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xQ3AGL+LgF8pEjrNl7Wc6Rrv6v4Dt8MV4joi7VdRQU6/Nzqu+neO6Qatvd6cCZqEEQTry/MSfps22kpuvbo+cA06hwZ6UoSls2WcPf8zBliVjIm5AKHSYBchlbIqdfp2YamvvhLiZhRNcToolgqsrMDiwRd2J6cwtEVOVLn8RkkUAFwfhywPf41WnsnVXkgGx7ursQVA+Wl1iArviyP1rWGA3uAI29hg/5kYJB0Gr5Kd/OMvcSY/TdrfbiW2L/3u/jOP78Qh4bkogync+kuaM2HwgLX58xhRHod/Ehr5z+GsLBLuKmUBq9hTnAXYE3HU4lwQqHE+kntdXlzlVslhg9J/HxeWETQlKEEl4bnIQXXRRAHGJrm22CwjOWAVKxuUiaykTvlbofW7pL7lyz0D0L5tiEfux3mnoUXWvSpJyOo=
Content-Type: text/plain; charset="iso-8859-2"
Content-ID: <6D4B28A594D3E1478A7E242F0B73EBBA@namprd12.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 205510b0-9e32-4f6d-45f7-08d748472382
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Oct 2019 21:17:47.3701
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nGY7ig+M1gp6mG7vhpIYngkOVrBv+b7egxoYKi0QB4BcnCZPHjtCAmUOfvunn8UUE8ED/zx9zS4mZ9XEszSxzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3115
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

In preparation for an upcoming patch, convert the mutex that guards the
DEACTIVATE/WBINVD/DF_FLUSH sequence into a read/write semaphore. The
conversion will convert the mutex lock and unlock into down_write and
up_write so that the mutex behavior is maintained.

Tested-by: David Rientjes <rientjes@google.com>
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 389dfd7594eb..b995d7ac1516 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -38,6 +38,7 @@
 #include <linux/file.h>
 #include <linux/pagemap.h>
 #include <linux/swap.h>
+#include <linux/rwsem.h>
=20
 #include <asm/apic.h>
 #include <asm/perf_event.h>
@@ -418,7 +419,7 @@ enum {
=20
 #define VMCB_AVIC_APIC_BAR_MASK		0xFFFFFFFFFF000ULL
=20
-static DEFINE_MUTEX(sev_deactivate_lock);
+static DECLARE_RWSEM(sev_deactivate_lock);
 static DEFINE_MUTEX(sev_bitmap_lock);
 static unsigned int max_sev_asid;
 static unsigned int min_sev_asid;
@@ -1762,14 +1763,14 @@ static void sev_unbind_asid(struct kvm *kvm, unsign=
ed int handle)
 	 * Guard against a parallel DEACTIVATE command before the DF_FLUSH
 	 * command has completed.
 	 */
-	mutex_lock(&sev_deactivate_lock);
+	down_write(&sev_deactivate_lock);
=20
 	sev_guest_deactivate(data, NULL);
=20
 	wbinvd_on_all_cpus();
 	sev_guest_df_flush(NULL);
=20
-	mutex_unlock(&sev_deactivate_lock);
+	up_write(&sev_deactivate_lock);
=20
 	kfree(data);
=20
--=20
2.17.1

