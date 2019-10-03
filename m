Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC032CB0F3
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2019 23:18:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732237AbfJCVRr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Oct 2019 17:17:47 -0400
Received: from mail-eopbgr810082.outbound.protection.outlook.com ([40.107.81.82]:48791
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729029AbfJCVRq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Oct 2019 17:17:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QcJsJ/wb9R+GB6e9CMSuKstvwwRx8QgRkq8h6YQ9VRuaHstifc9MJXczoxZoaeqIH607gQNA1wsqfVN9ktgrYXYZSURJk/Jh0qkH8SJJb1KTLFm6aA7YzeSx9mUzkU3z7E6+LbaRBe/nFXnDxpPOIe+nFm3P47k0OOSYFjWpYIR/SN9UXF5fYr88CfnWmwWarDLikA9+ASNlVNkxK4U5YzV/Augkb75qQ6J0xCdGudCMhykTPF8TQUyfiFenkJEliuMdUO/Ce48zoeV2blmkV9je30Tn+IrxH7QCXWHBlQLG3lGyg5C8S1DXhfhj8rByQECbF1cxNq3Eu0wpukvrzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TwqGdFpg1itFbkpP8DLz8O+PS7rEilDeb+3JTReRaBc=;
 b=LTeOYAUgGwugv9wxHrm7lxrDGp6zGhXd4cxUoWSmFmOWQycoiFLH433MNyFZa76PQzreYbNZ1t+McMSppOI3VcWpb+vc/oxANAqE/59DRxHdr7NOEnjeEJPbDzBLQuGZFquHkQClsd8bTZbdJWns+Sg/Y/DNsLzVPKPwj/PyVJYqKagTns4PzVVL1kEiaFjrbmN442jYvRt33nqc02lu9mwviQcE87ecct2YkOJwndcxy3Xr86yD4o73Du5j/IAEpcKLAof6yO4y/TigHr9bBVOaKg18ftdsckWFEu1TXsOovQpV1tbXeegKYLlB6ulIqZa0n2s3yWysUYcnSYZLag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TwqGdFpg1itFbkpP8DLz8O+PS7rEilDeb+3JTReRaBc=;
 b=GDhfKIGEZ5nwQ/L1mCvTiK4FF9kxu8Ls0s8o+UN61vyVR0iuP5GOC7QajUq9jnfFUX6c+rrl/NCr8IeAPzj1J0MXfv1lO98XoKGiLq3ydq/sPD2JhBPYv605YKiz6ENcwOjx/OnTtvDFjHqyhL6iK7XDScCVIif2NNlw7lXutxo=
Received: from DM6PR12MB3163.namprd12.prod.outlook.com (20.179.104.150) by
 DM6PR12MB3115.namprd12.prod.outlook.com (20.178.31.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.20; Thu, 3 Oct 2019 21:17:43 +0000
Received: from DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::85b7:7456:1a67:78aa]) by DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::85b7:7456:1a67:78aa%7]) with mapi id 15.20.2305.023; Thu, 3 Oct 2019
 21:17:43 +0000
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
Subject: [PATCH 1/5] KVM: SVM: Serialize access to the SEV ASID bitmap
Thread-Topic: [PATCH 1/5] KVM: SVM: Serialize access to the SEV ASID bitmap
Thread-Index: AQHVei/+q25933Ls5kKPMJeGuLAJPQ==
Date:   Thu, 3 Oct 2019 21:17:43 +0000
Message-ID: <0fc0372d446cb559c2a5b9389c5844df7582dc50.1570137447.git.thomas.lendacky@amd.com>
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
x-ms-office365-filtering-correlation-id: 148dcb1d-1a89-4110-811c-08d74847211f
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: DM6PR12MB3115:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB31151375AC61C9F750E15132EC9F0@DM6PR12MB3115.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 01792087B6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(396003)(376002)(346002)(136003)(189003)(199004)(26005)(256004)(14444005)(186003)(2906002)(102836004)(6512007)(99286004)(66946007)(476003)(14454004)(6436002)(446003)(8676002)(81166006)(8936002)(81156014)(478600001)(2501003)(11346002)(50226002)(71190400001)(71200400001)(36756003)(6116002)(76176011)(52116002)(86362001)(3846002)(486006)(386003)(6506007)(7736002)(316002)(25786009)(305945005)(5660300002)(7416002)(118296001)(66556008)(66446008)(64756008)(66476007)(4326008)(54906003)(110136005)(6486002)(66066001)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3115;H:DM6PR12MB3163.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oguROAvFNbPXfce7S6Osur4tJx1YfVI6eF+iCvdWuEcP5FaNytdvwAvmC7tVDrdiLV/x2egzDA+muAaLZco6ddDvJjIPf4qJPf3qNssiDx0yXNZ72cP9lwNdZeXW1FUF30E5IBQTA91mQNKJDtFY2zdoZ5wLm4WxOYobcqhuUF9m8XJHMSF4NALh/g58RYo2jQBIF8PR9pnp2TFHp+G+TYQqPzjoLtVfNEb9O+fpkfZ2Itt61zIrUh+gLvYyCAE3ED5V0QFIPzGB9XfISmphMtmu+izdlb+j/4ge3l0jBk0LuA5vn8Fr8XYqNA8D9MduU1NQaKtmpJvVTxQRT/RN3okFjQ4F3vvEDr55JGi4XlBbqY7BvTiOfKFLeHuqpfqBdlm4mNsn00EjHNHevWBda9LUJ4B2GgrCF2tu0RiIXqU=
Content-Type: text/plain; charset="iso-8859-2"
Content-ID: <705D6201B50DD84EB66BE1753323E0E9@namprd12.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 148dcb1d-1a89-4110-811c-08d74847211f
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Oct 2019 21:17:43.5832
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: D3fK5TccoWOWTxRQUVRLyme9MNEd1+DylsJzizsWPXFVUIFy86aQNXz418uTFJzGrgoRNct+BNf2/YUr1Ngjmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3115
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

The SEV ASID bitmap currently is not protected against parallel SEV guest
startups. This can result in an SEV guest failing to start because another
SEV guest could have been assigned the same ASID value. Use a mutex to
serialize access to the SEV ASID bitmap.

Fixes: 1654efcbc431 ("KVM: SVM: Add KVM_SEV_INIT command")
Tested-by: David Rientjes <rientjes@google.com>
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm.c | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index f8ecb6df5106..d371007ab109 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -418,6 +418,7 @@ enum {
=20
 #define VMCB_AVIC_APIC_BAR_MASK		0xFFFFFFFFFF000ULL
=20
+static DEFINE_MUTEX(sev_bitmap_lock);
 static unsigned int max_sev_asid;
 static unsigned int min_sev_asid;
 static unsigned long *sev_asid_bitmap;
@@ -1723,25 +1724,22 @@ static int avic_init_backing_page(struct kvm_vcpu *=
vcpu)
 	return 0;
 }
=20
-static void __sev_asid_free(int asid)
+static void sev_asid_free(int asid)
 {
 	struct svm_cpu_data *sd;
 	int cpu, pos;
=20
+	mutex_lock(&sev_bitmap_lock);
+
 	pos =3D asid - 1;
-	clear_bit(pos, sev_asid_bitmap);
+	__clear_bit(pos, sev_asid_bitmap);
=20
 	for_each_possible_cpu(cpu) {
 		sd =3D per_cpu(svm_data, cpu);
 		sd->sev_vmcbs[pos] =3D NULL;
 	}
-}
-
-static void sev_asid_free(struct kvm *kvm)
-{
-	struct kvm_sev_info *sev =3D &to_kvm_svm(kvm)->sev_info;
=20
-	__sev_asid_free(sev->asid);
+	mutex_unlock(&sev_bitmap_lock);
 }
=20
 static void sev_unbind_asid(struct kvm *kvm, unsigned int handle)
@@ -1910,7 +1908,7 @@ static void sev_vm_destroy(struct kvm *kvm)
 	mutex_unlock(&kvm->lock);
=20
 	sev_unbind_asid(kvm, sev->handle);
-	sev_asid_free(kvm);
+	sev_asid_free(sev->asid);
 }
=20
 static void avic_vm_destroy(struct kvm *kvm)
@@ -6268,14 +6266,21 @@ static int sev_asid_new(void)
 {
 	int pos;
=20
+	mutex_lock(&sev_bitmap_lock);
+
 	/*
 	 * SEV-enabled guest must use asid from min_sev_asid to max_sev_asid.
 	 */
 	pos =3D find_next_zero_bit(sev_asid_bitmap, max_sev_asid, min_sev_asid - =
1);
-	if (pos >=3D max_sev_asid)
+	if (pos >=3D max_sev_asid) {
+		mutex_unlock(&sev_bitmap_lock);
 		return -EBUSY;
+	}
+
+	__set_bit(pos, sev_asid_bitmap);
+
+	mutex_unlock(&sev_bitmap_lock);
=20
-	set_bit(pos, sev_asid_bitmap);
 	return pos + 1;
 }
=20
@@ -6303,7 +6308,7 @@ static int sev_guest_init(struct kvm *kvm, struct kvm=
_sev_cmd *argp)
 	return 0;
=20
 e_free:
-	__sev_asid_free(asid);
+	sev_asid_free(asid);
 	return ret;
 }
=20
--=20
2.17.1

