Return-Path: <kvm+bounces-39326-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 231D7A46951
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 19:17:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 17080173FD9
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 18:17:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CD1B23A9A4;
	Wed, 26 Feb 2025 18:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jI6E3uKN"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADB312397B4
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 18:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740593721; cv=none; b=qDb58hozXuRQieS3u5+Taphr7xrGjZp4aBmSA+oNmkt4kxKOq5fq3mbqCu0k5HvZb/u5CVuKAm2uCBD0u0epJxXaqkAp2R1dHr4IldnB3kd70mKwI5p7p5DhCMdx92ZiGWHV92FOPJbYTtf+7DhBdCzyyZg0zIBTCeTy+5Rt914=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740593721; c=relaxed/simple;
	bh=FlixckBccX6FBZzeGPG8flgsnluZb2qoVWfxMxTS69g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=juByDzb1Psfy1m91hs2dIjoX/YiQcNifD9DUwA+3mRXkH+Vl8Neoa2Ts0rSUcmrks584c4OSAokolnruNVl5e1fi//i1Fn18k+qqcl6jVDM3xZgUU/WZg9FOMIJzPVY53N8p7Q8mWDqjcvF4MTHecXBAkDAM/bhsFayLfxxPd7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jI6E3uKN; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740593718;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=496+NfmReiu1QtRFgMa3QzvQAaca1PTo3KmIjXjJBzw=;
	b=jI6E3uKNxMP/r6rWx7xiD89r32z/vyGRcPtGbho93eJ59hJ2G5SixrX0OPbZbWvYTBWSvY
	fY+T9JopvLb/ElNsuJTDd+ba48j335quQb0aIcyf+5Jx43fI/lmb0B6itT6Rm0cYXYdW3G
	UsKWEtQ9A/ido3SH0g/9oAmq6IJlfmc=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-679-QKPCKPIEPuefA4ZHN_t55g-1; Wed,
 26 Feb 2025 13:15:14 -0500
X-MC-Unique: QKPCKPIEPuefA4ZHN_t55g-1
X-Mimecast-MFC-AGG-ID: QKPCKPIEPuefA4ZHN_t55g_1740593713
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6F5DE180087F;
	Wed, 26 Feb 2025 18:15:13 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3872C1955BD4;
	Wed, 26 Feb 2025 18:15:12 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	Yan Zhao <yan.y.zhao@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Kai Huang <kai.huang@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>
Subject: [PATCH 11/33] x86/virt/tdx: Read essential global metadata for KVM
Date: Wed, 26 Feb 2025 13:14:30 -0500
Message-ID: <20250226181453.2311849-12-pbonzini@redhat.com>
In-Reply-To: <20250226181453.2311849-1-pbonzini@redhat.com>
References: <20250226181453.2311849-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

From: Kai Huang <kai.huang@intel.com>

KVM needs two classes of global metadata to create and run TDX guests:

 - "TD Control Structures"
 - "TD Configurability"

The first class contains the sizes of TDX guest per-VM and per-vCPU
control structures.  KVM will need to use them to allocate enough space
for those control structures.

The second class contains info which reports things like which features
are configurable to TDX guest etc.  KVM will need to use them to
properly configure TDX guests.

Read them for KVM TDX to use.

The code change is auto-generated by re-running the script in [1] after
uncommenting the "td_conf" and "td_ctrl" part to regenerate the
tdx_global_metadata.{hc} and update them to the existing ones in the
kernel.

  #python tdx.py global_metadata.json tdx_global_metadata.h \
	tdx_global_metadata.c

The 'global_metadata.json' can be fetched from [2].

Note that as of this writing, the JSON file only allows a maximum of 32
CPUID entries.  While this is enough for current contents of the CPUID
leaves, there were plans to change the JSON per TDX module release which
would change the ABI and potentially prevent future versions of the TDX
module from working with older kernels.

While discussions are ongoing with the TDX module team on what exactly
constitutes an ABI breakage, in the meantime the TDX module team has
agreed to not increase the number of CPUID entries beyond 128 without
an opt in.  Therefore the file was tweaked by hand to change the maximum
number of CPUID_CONFIGs.

Link: https://lore.kernel.org/kvm/0853b155ec9aac09c594caa60914ed6ea4dc0a71.camel@intel.com/ [1]
Link: https://cdrdv2.intel.com/v1/dl/getContent/795381 [2]
Signed-off-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Message-ID: <20241030190039.77971-4-rick.p.edgecombe@intel.com>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/virt/vmx/tdx/tdx_global_metadata.c | 50 +++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx_global_metadata.h | 19 ++++++++
 2 files changed, 69 insertions(+)

diff --git a/arch/x86/virt/vmx/tdx/tdx_global_metadata.c b/arch/x86/virt/vmx/tdx/tdx_global_metadata.c
index 8027a24d1c6e..13ad2663488b 100644
--- a/arch/x86/virt/vmx/tdx/tdx_global_metadata.c
+++ b/arch/x86/virt/vmx/tdx/tdx_global_metadata.c
@@ -37,12 +37,62 @@ static int get_tdx_sys_info_tdmr(struct tdx_sys_info_tdmr *sysinfo_tdmr)
 	return ret;
 }
 
+static int get_tdx_sys_info_td_ctrl(struct tdx_sys_info_td_ctrl *sysinfo_td_ctrl)
+{
+	int ret = 0;
+	u64 val;
+
+	if (!ret && !(ret = read_sys_metadata_field(0x9800000100000000, &val)))
+		sysinfo_td_ctrl->tdr_base_size = val;
+	if (!ret && !(ret = read_sys_metadata_field(0x9800000100000100, &val)))
+		sysinfo_td_ctrl->tdcs_base_size = val;
+	if (!ret && !(ret = read_sys_metadata_field(0x9800000100000200, &val)))
+		sysinfo_td_ctrl->tdvps_base_size = val;
+
+	return ret;
+}
+
+static int get_tdx_sys_info_td_conf(struct tdx_sys_info_td_conf *sysinfo_td_conf)
+{
+	int ret = 0;
+	u64 val;
+	int i, j;
+
+	if (!ret && !(ret = read_sys_metadata_field(0x1900000300000000, &val)))
+		sysinfo_td_conf->attributes_fixed0 = val;
+	if (!ret && !(ret = read_sys_metadata_field(0x1900000300000001, &val)))
+		sysinfo_td_conf->attributes_fixed1 = val;
+	if (!ret && !(ret = read_sys_metadata_field(0x1900000300000002, &val)))
+		sysinfo_td_conf->xfam_fixed0 = val;
+	if (!ret && !(ret = read_sys_metadata_field(0x1900000300000003, &val)))
+		sysinfo_td_conf->xfam_fixed1 = val;
+	if (!ret && !(ret = read_sys_metadata_field(0x9900000100000004, &val)))
+		sysinfo_td_conf->num_cpuid_config = val;
+	if (!ret && !(ret = read_sys_metadata_field(0x9900000100000008, &val)))
+		sysinfo_td_conf->max_vcpus_per_td = val;
+	if (sysinfo_td_conf->num_cpuid_config > ARRAY_SIZE(sysinfo_td_conf->cpuid_config_leaves))
+		return -EINVAL;
+	for (i = 0; i < sysinfo_td_conf->num_cpuid_config; i++)
+		if (!ret && !(ret = read_sys_metadata_field(0x9900000300000400 + i, &val)))
+			sysinfo_td_conf->cpuid_config_leaves[i] = val;
+	if (sysinfo_td_conf->num_cpuid_config > ARRAY_SIZE(sysinfo_td_conf->cpuid_config_values))
+		return -EINVAL;
+	for (i = 0; i < sysinfo_td_conf->num_cpuid_config; i++)
+		for (j = 0; j < 2; j++)
+			if (!ret && !(ret = read_sys_metadata_field(0x9900000300000500 + i * 2 + j, &val)))
+				sysinfo_td_conf->cpuid_config_values[i][j] = val;
+
+	return ret;
+}
+
 static int get_tdx_sys_info(struct tdx_sys_info *sysinfo)
 {
 	int ret = 0;
 
 	ret = ret ?: get_tdx_sys_info_features(&sysinfo->features);
 	ret = ret ?: get_tdx_sys_info_tdmr(&sysinfo->tdmr);
+	ret = ret ?: get_tdx_sys_info_td_ctrl(&sysinfo->td_ctrl);
+	ret = ret ?: get_tdx_sys_info_td_conf(&sysinfo->td_conf);
 
 	return ret;
 }
diff --git a/arch/x86/virt/vmx/tdx/tdx_global_metadata.h b/arch/x86/virt/vmx/tdx/tdx_global_metadata.h
index 6dd3c9695f59..060a2ad744bf 100644
--- a/arch/x86/virt/vmx/tdx/tdx_global_metadata.h
+++ b/arch/x86/virt/vmx/tdx/tdx_global_metadata.h
@@ -17,9 +17,28 @@ struct tdx_sys_info_tdmr {
 	u16 pamt_1g_entry_size;
 };
 
+struct tdx_sys_info_td_ctrl {
+	u16 tdr_base_size;
+	u16 tdcs_base_size;
+	u16 tdvps_base_size;
+};
+
+struct tdx_sys_info_td_conf {
+	u64 attributes_fixed0;
+	u64 attributes_fixed1;
+	u64 xfam_fixed0;
+	u64 xfam_fixed1;
+	u16 num_cpuid_config;
+	u16 max_vcpus_per_td;
+	u64 cpuid_config_leaves[128];
+	u64 cpuid_config_values[128][2];
+};
+
 struct tdx_sys_info {
 	struct tdx_sys_info_features features;
 	struct tdx_sys_info_tdmr tdmr;
+	struct tdx_sys_info_td_ctrl td_ctrl;
+	struct tdx_sys_info_td_conf td_conf;
 };
 
 #endif
-- 
2.43.5



