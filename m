Return-Path: <kvm+bounces-25412-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 95A799652D2
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 00:25:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 152261F24666
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 22:25:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4465A1BBBD3;
	Thu, 29 Aug 2024 22:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="fM2sBu6R"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AA1B1BA86D;
	Thu, 29 Aug 2024 22:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724970277; cv=none; b=klcEv4iy9ueVdjt4fzwfaJFtAZYCbB2gqw6VrquC5f2PcO7CA9bjtGlwqnvk7sU6ekQjcC47g579qlRLgR+BIft38Yp4KiC0VSWfQTCjtXx7UFz+Zk7bZaAuGqs6slWmCWXgiwgDQ+nNAI1XUxANFvThIANTuHZDzHz0A2A8f+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724970277; c=relaxed/simple;
	bh=JFiV4jG07K1U1tQP1F+UO+KbTnuHVESnTnQYsb4NNmE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=HgPtiut10OzTwt9gq0FnXNWo0xn3Ikmf3OMEwlX5BW0zfx4ImfMHxUzS02DY//vrT+jPDPU37cQ82A0nca/XX8OEZlwHmEfvJ/YhXjTsQPRJGLc6ICFoifaT8nWBYMskMmfdqIprffX+GAfhu25UdP+Xhw5hn7UhCLyD7AluvSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=fM2sBu6R; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47THw8rh019432;
	Thu, 29 Aug 2024 22:24:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	nqQKk6MOQFV+1+R4/XWf2oHD5kh81okffsDtSVIGLYM=; b=fM2sBu6RSAMa+ucj
	chXJ2MezexBJDEBCe/1qL3cvNUY38wxUpB840yteHKfkLEtg+rmzWTVHaTPZPZDs
	9lFDjTsCSD2R9C4P0eLlBMp8QeB2Fk6GFvXj8b8F6RPJ/DTwgrERrbtJejUYUG46
	B5rXXJlJmNctWJpmTZYM37VyeP5YEKq+G+Kv6rn8lC0X8fBBkUun/avqj308QRK0
	WY9ALgZjDJGr96vtS26rOpacPGJ9OG5q31ntkRPb1d6cqZ6SendYtAMCWMMKvcny
	XvcnI+HZWGzbxJFZZZ4QGInrsZzV193YMdFePOc0RKx9QhA2zNSecMavVvbTVGwz
	XcJodA==
Received: from nasanppmta04.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 419putpu29-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 29 Aug 2024 22:24:13 +0000 (GMT)
Received: from nasanex01b.na.qualcomm.com (nasanex01b.na.qualcomm.com [10.46.141.250])
	by NASANPPMTA04.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 47TMODPG023594
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 29 Aug 2024 22:24:13 GMT
Received: from hu-eberman-lv.qualcomm.com (10.49.16.6) by
 nasanex01b.na.qualcomm.com (10.46.141.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.9; Thu, 29 Aug 2024 15:24:12 -0700
From: Elliot Berman <quic_eberman@quicinc.com>
Date: Thu, 29 Aug 2024 15:24:12 -0700
Subject: [PATCH RFC v2 4/5] mm: guest_memfd: Add ability for userspace to
 mmap pages
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20240829-guest-memfd-lib-v2-4-b9afc1ff3656@quicinc.com>
References: <20240829-guest-memfd-lib-v2-0-b9afc1ff3656@quicinc.com>
In-Reply-To: <20240829-guest-memfd-lib-v2-0-b9afc1ff3656@quicinc.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Sean Christopherson
	<seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner
	<tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov
	<bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Fuad Tabba
	<tabba@google.com>, David Hildenbrand <david@redhat.com>,
        Patrick Roy
	<roypat@amazon.co.uk>, <qperret@google.com>,
        Ackerley Tng
	<ackerleytng@google.com>,
        Mike Rapoport <rppt@kernel.org>, <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
        <linux-arm-msm@vger.kernel.org>,
        Elliot Berman <quic_eberman@quicinc.com>
X-Mailer: b4 0.14.1
X-ClientProxiedBy: nalasex01a.na.qualcomm.com (10.47.209.196) To
 nasanex01b.na.qualcomm.com (10.46.141.250)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: YoBcGu8s-izQ3-pSoL8-J8hiQQsRjEyp
X-Proofpoint-ORIG-GUID: YoBcGu8s-izQ3-pSoL8-J8hiQQsRjEyp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-29_06,2024-08-29_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 phishscore=0 adultscore=0 priorityscore=1501
 impostorscore=0 malwarescore=0 suspectscore=0 spamscore=0 bulkscore=0
 mlxlogscore=882 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2407110000 definitions=main-2408290158

"Inaccessible" and "accessible" state are properly tracked by the
guest_memfd. Userspace can now safely access pages to preload binaries
in a hypervisor/architecture-agnostic manner.

Signed-off-by: Elliot Berman <quic_eberman@quicinc.com>
---
 mm/guest_memfd.c | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/mm/guest_memfd.c b/mm/guest_memfd.c
index 62cb576248a9d..194b2c3ea1525 100644
--- a/mm/guest_memfd.c
+++ b/mm/guest_memfd.c
@@ -279,6 +279,51 @@ int guest_memfd_make_inaccessible(struct folio *folio)
 }
 EXPORT_SYMBOL_GPL(guest_memfd_make_inaccessible);
 
+static vm_fault_t gmem_fault(struct vm_fault *vmf)
+{
+	struct file *file = vmf->vma->vm_file;
+	struct guest_memfd_private *private;
+	struct folio *folio;
+
+	folio = guest_memfd_grab_folio(file, vmf->pgoff, GUEST_MEMFD_GRAB_ACCESSIBLE);
+	if (IS_ERR(folio))
+		return VM_FAULT_SIGBUS;
+
+	vmf->page = folio_page(folio, vmf->pgoff - folio_index(folio));
+
+	/**
+	 * Drop the safe and accessible references, the folio refcount will
+	 * be preserved and unmap_mapping_folio() will decrement the
+	 * refcount when converting to inaccessible.
+	 */
+	private = folio_get_private(folio);
+	atomic_dec(&private->accessible);
+	atomic_dec(&private->safe);
+
+	return VM_FAULT_LOCKED;
+}
+
+static const struct vm_operations_struct gmem_vm_ops = {
+	.fault = gmem_fault,
+};
+
+static int gmem_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	const struct guest_memfd_operations *ops = file_inode(file)->i_private;
+
+	if (!ops->prepare_accessible)
+		return -EPERM;
+
+	/* No support for private mappings to avoid COW.  */
+	if ((vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) !=
+	    (VM_SHARED | VM_MAYSHARE))
+		return -EINVAL;
+
+	file_accessed(file);
+	vma->vm_ops = &gmem_vm_ops;
+	return 0;
+}
+
 static long gmem_punch_hole(struct file *file, loff_t offset, loff_t len)
 {
 	struct inode *inode = file_inode(file);
@@ -390,6 +435,7 @@ static int gmem_release(struct inode *inode, struct file *file)
 static const struct file_operations gmem_fops = {
 	.open = generic_file_open,
 	.llseek = generic_file_llseek,
+	.mmap = gmem_mmap,
 	.release = gmem_release,
 	.fallocate = gmem_fallocate,
 	.owner = THIS_MODULE,

-- 
2.34.1


