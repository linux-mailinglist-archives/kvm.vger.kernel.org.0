Return-Path: <kvm+bounces-61224-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 15632C118B6
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 22:24:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id EAAAC4F983A
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 21:22:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FAFA32AADD;
	Mon, 27 Oct 2025 21:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="Eg2EjnVG"
X-Original-To: kvm@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08B2F2E22A6;
	Mon, 27 Oct 2025 21:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761600119; cv=none; b=LXfMyusFvVfKYaXYcqL79pk73AVfJqsb0zHQW2xiNmbQEMemTVVWNKtjdPbgB/OatsKkU5l3mkLtMXsH0OWPeyUulBmbVimwaHaoUNfHscX1HFP5JAJ/zWjbaHYYPUUQPbLv10oXo7cxI93EH3YJCltATdfBfoN+NsqbjZ4X8iQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761600119; c=relaxed/simple;
	bh=Vy4SHCr7raGjYOr05guIcmLTlVdtJNy1rrIG1WAivlo=;
	h=Message-ID:Date:MIME-Version:To:From:Cc:Subject:Content-Type; b=jcWOmyuAPzcUWuT0AvNa90MgIfhu3AiZGCTu5twk00iiVmcfuBfMTg7J25HO8B0W8sUb/gLwqMJly65UxYhLJX30LWIclrEIunwL8HqythtIXvVw6tpmQnWAGBk13qMb6zeE7NU22vy7vjzYXOnyElcHWvxq4v4KFGHLOVVb21g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=Eg2EjnVG; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: from [192.168.0.88] (192-184-212-33.fiber.dynamic.sonic.net [192.184.212.33])
	by linux.microsoft.com (Postfix) with ESMTPSA id 0DC96200FE4F;
	Mon, 27 Oct 2025 14:21:57 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 0DC96200FE4F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1761600117;
	bh=zo4Zdd3KS4ECy8lsDT32wIILISFjSmQ/bpZ4QJoW+rM=;
	h=Date:To:From:Cc:Subject:From;
	b=Eg2EjnVGAJDtCBAM0ob1IWBvuUaCz2w+EpjVgvIW1jQ1hVlmhf6Fs+3vWMNvFBaLC
	 K/IurUGKx+oehnRQmg2bKCaLcd2qq7XnmR7VvVAuHpX2qjEv48VT/Hn1iW7tyOX6hB
	 8j3/RyiRqne4/y1HGeX2J7eM4afHM9NVVS3TZR78=
Message-ID: <a9b8a3ee-b35b-5c45-5042-2466607abcd0@linux.microsoft.com>
Date: Mon, 27 Oct 2025 14:21:56 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Content-Language: en-US
To: alex.williamson@redhat.com, joe@perches.com
From: Mukesh R <mrathor@linux.microsoft.com>
Cc: kvm@vger.kernel.org,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
 "wei.liu@kernel.org" <wei.liu@kernel.org>
Subject: [RFC] Making vma_to_pfn() public (due to vm_pgoff change)
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Alex,

This regards vfio passthru support on hyperv running linux as dom0 aka
root. At a high level, cloud hypervisor uses vfio for set up as usual,
then maps the mmio ranges via the hyperv linux driver ioctls.

Over a year ago, when working on this I had used vm_pgoff to get the pfn
for the mmio, that was 5.15 and early 6.x kernels. Now that I am porting
to 6.18 for upstreaming, I noticed:

commit aac6db75a9fc
Author: Alex Williamson <alex.williamson@redhat.com>
    vfio/pci: Use unmap_mapping_range()

changed the behavior and vm_pgoff is no longer holding the pfn. In light
of that, I wondered if the following minor change, making vma_to_pfn() 
public (after renaming it), would be acceptable to you.

Thanks,
-Mukesh

-----------------------------------------------------------------------------
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 7dcf5439dedc..43083a16d8a2 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1628,7 +1628,7 @@ void vfio_pci_memory_unlock_and_restore(struct vfio_pci_core_device *vdev, u16 c
 	up_write(&vdev->memory_lock);
 }
 
-static unsigned long vma_to_pfn(struct vm_area_struct *vma)
+unsigned long vfio_pci_vma_to_pfn(struct vm_area_struct *vma)
 {
 	struct vfio_pci_core_device *vdev = vma->vm_private_data;
 	int index = vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
@@ -1647,7 +1647,7 @@ static vm_fault_t vfio_pci_mmap_huge_fault(struct vm_fault *vmf,
 	struct vfio_pci_core_device *vdev = vma->vm_private_data;
 	unsigned long addr = vmf->address & ~((PAGE_SIZE << order) - 1);
 	unsigned long pgoff = (addr - vma->vm_start) >> PAGE_SHIFT;
-	unsigned long pfn = vma_to_pfn(vma) + pgoff;
+	unsigned long pfn = vfio_pci_vma_to_pfn(vma) + pgoff;
 	vm_fault_t ret = VM_FAULT_SIGBUS;
 
 	if (order && (addr < vma->vm_start ||
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index f541044e42a2..88925c6b8a22 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -119,6 +119,7 @@ ssize_t vfio_pci_core_read(struct vfio_device *core_vdev, char __user *buf,
 		size_t count, loff_t *ppos);
 ssize_t vfio_pci_core_write(struct vfio_device *core_vdev, const char __user *buf,
 		size_t count, loff_t *ppos);
+unsigned long vfio_pci_vma_to_pfn(struct vm_area_struct *vma);
 int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma);
 void vfio_pci_core_request(struct vfio_device *core_vdev, unsigned int count);
 int vfio_pci_core_match(struct vfio_device *core_vdev, char *buf);



