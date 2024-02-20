Return-Path: <kvm+bounces-9113-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B1E8385B0F6
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 03:48:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 162A3B22992
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 02:48:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0927941215;
	Tue, 20 Feb 2024 02:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="sVuqROMi"
X-Original-To: kvm@vger.kernel.org
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 450EB2E405;
	Tue, 20 Feb 2024 02:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708397289; cv=none; b=p+/+47ZuGVG+jbN9n8WiwRKJyQYYQpcZ0+gz8ezoalf6IG8A0m1drvM3TS4eHDadryq0M95CxIwFscU2fawT7AkhVDDm0XqhvLvMQ274LBgdHpPILbDVGEkDMwvbhKdPJJsMxmQn727Fy0ySkMCWF4axCC1MDcA9NM7kRsuLJjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708397289; c=relaxed/simple;
	bh=gW8PiThJNQZ5FS6YlG6JbBxKrlbLQJE1IW//TvIJxPw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=DgCZAsjw2FvIeI+6I3oMgAkSTVn0zXkTeh5anoHqhxUIpm6Dm0t+3gDnzLbZbZf8l1nUV/o2dTh5CA/nTcwVPyOy4NuQxRJwr/98hbl1UgR0YY6voLHFjIgYF8Z9OrgmdT0WtPgcX9bqXZqTIvlOeM6M5Ibrhx7EL1VsijafhIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au; spf=pass smtp.mailfrom=canb.auug.org.au; dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b=sVuqROMi; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canb.auug.org.au
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
	s=201702; t=1708397282;
	bh=Z4i2HgUFZGcYAnFlUo70X5l7wimYk9KDMghPc8ouFB0=;
	h=Date:From:To:Cc:Subject:From;
	b=sVuqROMiVrTxIczX4g1b2YhlfT9Y1oa/RcBKuXd1AY6eHRELs8EGsfq+sDYJce7rp
	 go7p24EFHF/oYrTzLOojgEsPdeU7JGuX0Cd0L2QqBhUrCf9rJnuxsZDHnntOJAvQWU
	 PIiDgq5+rhUYQTIWWWI1cN6OFzcBqSPU3hSAGCQo0/k/FXBcX28YZQVUEqilF9D2rr
	 CljuIvaRPGeoRzFZT8MqxX0opl+SqCN7ZPD17GkMIsZ2Ok2vOtu+PbQftJZ4v4gHrM
	 CP0CiasxhIyVCT/jxOHDLCOmrd7k/zWg2fFl6iZGLwIV6qKjd6nlf0pkRuciOWXkVk
	 BXfjkcA+b9mGQ==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4Tf3js5dmBz4wc7;
	Tue, 20 Feb 2024 13:48:01 +1100 (AEDT)
Date: Tue, 20 Feb 2024 13:48:00 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>
Cc: KVM <kvm@vger.kernel.org>, Linux Kernel Mailing List
 <linux-kernel@vger.kernel.org>, Linux Next Mailing List
 <linux-next@vger.kernel.org>, Paul Durrant <pdurrant@amazon.com>
Subject: linux-next: manual merge of the kvm-x86 tree with the kvm tree
Message-ID: <20240220134800.40efe653@canb.auug.org.au>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/A144DtVpcjR0fVyttz24FeA";
 protocol="application/pgp-signature"; micalg=pgp-sha256

--Sig_/A144DtVpcjR0fVyttz24FeA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm-x86 tree got a conflict in:

  include/uapi/linux/kvm.h

between commit:

  bcac0477277e ("KVM: x86: move x86-specific structs to uapi/asm/kvm.h")

from the kvm tree and commits:

  01a871852b11 ("KVM: x86/xen: allow shared_info to be mapped by fixed HVA")
  3a0c9c41959d ("KVM: x86/xen: allow vcpu_info to be mapped by fixed HVA")

from the kvm-x86 tree.

I fixed it up (I used the former version of this file and applied the
following fix up patch) and can carry the fix as necessary. This is now
fixed as far as linux-next is concerned, but any non trivial conflicts
should be mentioned to your upstream maintainer when your tree is
submitted for merging.  You may also want to consider cooperating with
the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 20 Feb 2024 13:44:11 +1100
Subject: [PATCH] fixup for code moving to arch/x86/include/uapi/asm/kvm.h

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/x86/include/uapi/asm/kvm.h | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kv=
m.h
index 0ad6bda1fc39..ad29984d5e39 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -549,6 +549,7 @@ struct kvm_x86_mce {
 #define KVM_XEN_HVM_CONFIG_EVTCHN_SEND		(1 << 5)
 #define KVM_XEN_HVM_CONFIG_RUNSTATE_UPDATE_FLAG	(1 << 6)
 #define KVM_XEN_HVM_CONFIG_PVCLOCK_TSC_UNSTABLE	(1 << 7)
+#define KVM_XEN_HVM_CONFIG_SHARED_INFO_HVA	(1 << 8)
=20
 struct kvm_xen_hvm_config {
 	__u32 flags;
@@ -567,9 +568,10 @@ struct kvm_xen_hvm_attr {
 		__u8 long_mode;
 		__u8 vector;
 		__u8 runstate_update_flag;
-		struct {
+		union {
 			__u64 gfn;
 #define KVM_XEN_INVALID_GFN ((__u64)-1)
+			__u64 hva;
 		} shared_info;
 		struct {
 			__u32 send_port;
@@ -611,6 +613,8 @@ struct kvm_xen_hvm_attr {
 #define KVM_XEN_ATTR_TYPE_XEN_VERSION		0x4
 /* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_RUNSTATE_UPDATE_FLA=
G */
 #define KVM_XEN_ATTR_TYPE_RUNSTATE_UPDATE_FLAG	0x5
+/* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_SHARED_INFO_HVA */
+#define KVM_XEN_ATTR_TYPE_SHARED_INFO_HVA	0x6
=20
 struct kvm_xen_vcpu_attr {
 	__u16 type;
@@ -618,6 +622,7 @@ struct kvm_xen_vcpu_attr {
 	union {
 		__u64 gpa;
 #define KVM_XEN_INVALID_GPA ((__u64)-1)
+		__u64 hva;
 		__u64 pad[8];
 		struct {
 			__u64 state;
@@ -648,6 +653,8 @@ struct kvm_xen_vcpu_attr {
 #define KVM_XEN_VCPU_ATTR_TYPE_VCPU_ID		0x6
 #define KVM_XEN_VCPU_ATTR_TYPE_TIMER		0x7
 #define KVM_XEN_VCPU_ATTR_TYPE_UPCALL_VECTOR	0x8
+/* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_SHARED_INFO_HVA */
+#define KVM_XEN_VCPU_ATTR_TYPE_VCPU_INFO_HVA	0x9
=20
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
--=20
2.43.0

--=20
Cheers,
Stephen Rothwell

--Sig_/A144DtVpcjR0fVyttz24FeA
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmXUEuAACgkQAVBC80lX
0Gzk5gf/ZqyZKU4mrYdDzO3ayPcqIfP0uGNR0Y9blW43TEkmk1AbzT5bzIPpOFZZ
4vX2y2LfrfZkeo5pK1uiknq50Z8RwX3yyeYVM1W5/az/z8BHzsEuVbonw3vTjI2v
3Ompv+y2Vs83d31ZCWqmNnuMhL95gDeiZJkr8uPs+wZ8UmHxzf12u7v6nTaeQXj9
oosPhKo95u8ThiW4xHmkpDx6sRbX5l/kzaIUAj7r9GyX5zGbe2M75UHVPZe+dY2K
7sLHKU+ccvEb8XdG7afg426byR8YmTdmGukYz8NM6xQQbwVTzcWsmeuK24UQXTpg
5hIv1dpGhPos3I5s1Pk4gcKpvY67GA==
=JsQc
-----END PGP SIGNATURE-----

--Sig_/A144DtVpcjR0fVyttz24FeA--

