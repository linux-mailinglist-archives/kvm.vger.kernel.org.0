Return-Path: <kvm+bounces-25682-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E937F968A32
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 16:42:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A5943282EA7
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 14:42:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8894619F126;
	Mon,  2 Sep 2024 14:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=erbse.13@gmx.de header.b="qM14gzK1"
X-Original-To: kvm@vger.kernel.org
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D62613D8AC;
	Mon,  2 Sep 2024 14:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725288156; cv=none; b=t6lbujIqshhAIj4j16YhjM0LjaGnZYWyb1JBScBoV1rE0nrEe/sb54iXkFxIOpdm8m/nijuDphexY6y/6dLetcF7OFYdbQoTvy+aUaY9FlK9Yug9Z4F1A1ejUc9/+1PsPzkntKDaw2ZlEXnXWjcmI7qmyn/CBMDOpwkEj96ov18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725288156; c=relaxed/simple;
	bh=HjTrG1MqVWIqW/AoFS6UIQX73yyNUBpQuRGQTkx/pRg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=H9Inwr54OQMBKYCLKFNhMZh+hWIzRWHMqJE5Zy+7Um2xtCGdwyKBDTy1FgDAerobfN+X/7YpEyoFHNhWLyPinfIXi2xTiuHIDtFvPNeKKzy3tfX/e0DFwK4+TgLneNoD6cOyMUiTMzatp2lp0lg3lUYVbLw6L1pb5HL4kY6lmv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=erbse.13@gmx.de header.b=qM14gzK1; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1725288147; x=1725892947; i=erbse.13@gmx.de;
	bh=JuEsxgQ+nZKinW+yzaKzsLhGNFeV1xPSyfzOhRHORPI=;
	h=X-UI-Sender-Class:From:To:Cc:Subject:Date:Message-Id:
	 MIME-Version:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=qM14gzK1AaVLoIbqEWksOE1mIJxlzOhiZd1kKZYJkkZqJ4x1UrQfril/dOE4SQD0
	 SDE4yios9oUxNtDElZVHoyh5YH7jzMHQ9fyYw+0go02+YJqINIID7zUf3SrzRF17r
	 eXtngCcJyodG4PEN00PocijX4dOoEoru6sIMard7OVhAqeWa8/ALSRT2jqkHewkUh
	 MRD6fqbpwL/lXHGHun2QnkD/AUe0NNmUIuD+CHj+3/jpGhl3UEWTb1ML9DruwVOuN
	 c6yuqCHchFwu+e5Clx1ibJ715LU6ZBaeo3IHByJ9f6XPpV0d+kVstQvXJcsczaMTg
	 l7yo3TL5K5f4m6nLIQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from server ([109.192.237.113]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1N9MpY-1rxTYV1C3I-0183QL; Mon, 02
 Sep 2024 16:42:27 +0200
From: Tom Dohrmann <erbse.13@gmx.de>
To: Tom Dohrmann <erbse.13@gmx.de>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Michael Roth <michael.roth@amd.com>
Subject: [PATCH] KVM: x86: Only advertise KVM_CAP_READONLY_MEM when supported by VM
Date: Mon,  2 Sep 2024 14:42:19 +0000
Message-Id: <20240902144219.3716974-1-erbse.13@gmx.de>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:qF2iiGLas2rIyTHizeaxY+qsu3prP0XvEt6mGspNYNqG5wItrVs
 YLcpVuLbyzlLGnlmL3V/WUpEPINzTRrSHntYOwwX3Rtmi1rpJNB+CsjsVkLGKGChXhJGC8Q
 TfAwA/KU+K50da4uFkox3WqARq7PDa7DmJL6g/h3oymRz0NORuN/lWoseTplszHCjaYua48
 JmHSq9Q8h+IW1c5SG6f8w==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:6mg2KCQxedc=;Y2cX8yOfuEaCOS6fu4VIBCKFVod
 VMx9JnKmbdFm+AWk9LiZlYRlZ/IGqi13coWv76jIxEGq9fLxfHd1z3Mc4hW8Gtiw4fHlIW4d3
 SrVluqdEhLR56OW+gHzPxI31+1jQVtWfkvjyF9tiqkOw2KswaaWPifCN+fE/0Qcsu1DRrVBuG
 85VZGfUVGvhZNSJM0DD3Fz4SssoXbqq2r5+6qdovQJKmVnEXhgZSQ1CjL2sqjy7Mi5/CFgKAp
 wWRtlRO53MqeC/wCsXFjtl+ZOoQupsD1JA6D/zj6qeMEjnQkkwiRPzru3FFbFwGSXnLbKShOm
 9o8TDxPBrvJNIzcla8c0a8RitLADP4gtAVe7Dy1qDddqfXbE8f/dIqYtqwpVI7igOEMtjl3t8
 FWiogYeNvpQQ4aZbfC/5D2iSqEN2fyrqvHhLTh1mZGlrvMaYR2ewnR7siBbE1a3YOLhLY26aR
 VRLznQwYuegQeHuZIivNpNxc/U5lqTWQwepGi8ONcl6TEEwRZNHyvpYxsx0QZEh7WQ4ugEr4l
 HOVX/E5a8WL9a+1qjjP27NaibX8mglO82BySxf3MK1j4pLk3TLJAWf6zY31o04wU27z19r792
 6OnPrE+5fld366jLSOsagqu/Oa16kvqFE1L+H/mLNI2Ix0YY/hcrCNT37lMf8hVOZWgy4ToKw
 ViIfYNBpniPF+IaHLC2jZKLw/ArRfPuZGL2QdAzUnaVg1RLXSFlCEWHUOPx5Mv/1ehS8bmBQY
 zX9/nK4G2OPpkTfnHN5hB+C48+vewHRfXAmQHgXjsiDLfuTlCiI3v38rh+yrJcBPevdRjW8Xk
 P0nuQmH59sYvFWhI7BOPTpFg==

Until recently, KVM_CAP_READONLY_MEM was unconditionally supported on
x86, but this is no longer the case for SEV-ES and SEV-SNP VMs.

When KVM_CHECK_EXTENSION is invoked on a VM, only advertise
KVM_CAP_READONLY_MEM when it's actually supported.

Fixes: 66155de93bcf ("KVM: x86: Disallow read-only memslots for SEV-ES and=
 SEV-SNP (and TDX)")
Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Michael Roth <michael.roth@amd.com>
Signed-off-by: Tom Dohrmann <erbse.13@gmx.de>
=2D--
 arch/x86/kvm/x86.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 70219e406987..9ad7fe279e72 100644
=2D-- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4656,7 +4656,6 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, lo=
ng ext)
 	case KVM_CAP_ASYNC_PF_INT:
 	case KVM_CAP_GET_TSC_KHZ:
 	case KVM_CAP_KVMCLOCK_CTRL:
-	case KVM_CAP_READONLY_MEM:
 	case KVM_CAP_IOAPIC_POLARITY_IGNORED:
 	case KVM_CAP_TSC_DEADLINE_TIMER:
 	case KVM_CAP_DISABLE_QUIRKS:
@@ -4815,6 +4814,8 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, lo=
ng ext)
 	case KVM_CAP_VM_TYPES:
 		r =3D kvm_caps.supported_vm_types;
 		break;
+	case KVM_CAP_READONLY_MEM:
+		r =3D kvm ? kvm_arch_has_readonly_mem(kvm) : 1;
 	default:
 		break;
 	}
=2D-
2.34.1


