Return-Path: <kvm+bounces-59519-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 533EABBDE0A
	for <lists+kvm@lfdr.de>; Mon, 06 Oct 2025 13:36:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E25E73AD505
	for <lists+kvm@lfdr.de>; Mon,  6 Oct 2025 11:36:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3607526A0F8;
	Mon,  6 Oct 2025 11:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AipNQtqX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F9292652AF
	for <kvm@vger.kernel.org>; Mon,  6 Oct 2025 11:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759750584; cv=none; b=LMyQLILikehF3O8NeVUJfgKHkcEEpqPlcuLOaNsfCfCg/872fyNZjT9bEV1DcEZ+DYY8JHXwv8jMysIBP8CV/TioleUiKYH9zh2CFpmvzQ5LkcoOS/PKQ5hKel31x24GfMa3q+B08pH9H+vqAhFxTCUj0mT4ZTB7v6EsQwe7/a8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759750584; c=relaxed/simple;
	bh=uCuHvL3BABbKRCcQcekmSCluWfg5LTWwUVu5B02dLXk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=h6E1xarOiclVOIS2Aq1vvAE2sPPdZTuIh05/9YEnWnwm1gFqemy4hiindFm1cVx+ILiKRQ8ZxVA8HtzvNV+KO9vM/DaIQnSetK5Vn6w43B5ONGfnOKdpYJ9/K05nJfMJW1v25QqulXIDwGtKPRAJIb4PYEOWmzlKrYCPRIM+uso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AipNQtqX; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759750582; x=1791286582;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=uCuHvL3BABbKRCcQcekmSCluWfg5LTWwUVu5B02dLXk=;
  b=AipNQtqX1qEUg12Ankx/R7eAddODxbfavdn/l0Sezi6rxoY8X97SeuyR
   8BN/K/CS4/KnD53zFUqezJYKnG+OnqzJAjOyWTILbZ6ffhjjVQIUWlxzt
   VOjlqOfr6u8bvOdWR3SKQUwmCHzPwzkEntj6aOkeIFdoHcgzrFDTruzFI
   4MD+5NzgKsY70iCNUxBxPYQ6eFcYETFSW+EVwtSCEfGisUSZWKQR4KjhY
   OlfmSMc1b7Fb+Q7OTUGRu1kwOPn/jNEJwJdYkUvf9/DY4oTp2ypivRJCo
   S3uCVd8dQtYBgBcPdDhxKKUAMA0xhOus+NK0eB9gQbrY53p7cSmbl7NIX
   Q==;
X-CSE-ConnectionGUID: JJoCRhy2RcC4OgMOjNlluA==
X-CSE-MsgGUID: Swcs4ni8TBWDPs05z45Edw==
X-IronPort-AV: E=McAfee;i="6800,10657,11573"; a="60958754"
X-IronPort-AV: E=Sophos;i="6.18,319,1751266800"; 
   d="scan'208";a="60958754"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2025 04:36:21 -0700
X-CSE-ConnectionGUID: 21MsPzX3QZqb+NtUdgLd1Q==
X-CSE-MsgGUID: DA/SfbjgRTKCZ6hlmiSE0g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,319,1751266800"; 
   d="scan'208";a="210815054"
Received: from ettammin-mobl2.ger.corp.intel.com (HELO tlindgre-MOBL1..) ([10.245.246.151])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2025 04:36:13 -0700
From: Tony Lindgren <tony.lindgren@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: Peter Xu <peterx@redhat.com>,
	Fabiano Rosas <farosas@suse.de>,
	Dhaval Giani <dhaval.giani@amd.com>,
	Jon Grimm <Jon.Grimm@amd.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Steven Price <steven.price@arm.com>,
	Anup Patel <anup@brainfault.org>,
	Samuel Ortiz <sameo@rivosinc.com>,
	=?UTF-8?q?Jakub=20R=C5=AF=C5=BEi=C4=8Dka?= <jakub.ruzicka@matfyz.cz>,
	=?UTF-8?q?J=C3=B6rg=20R=C3=B6del=20?= <joro@8bytes.org>,
	Vishal Annapurve <vannapurve@google.com>,
	Binbin Wu <binbin.wu@linux.intel.com>,
	Elena Reshetova <elena.reshetova@intel.com>,
	Kai Huang <kai.huang@intel.com>,
	Kishen Maloor <kishen.maloor@intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Peter Fang <peter.fang@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	kvm@vger.kernel.org
Subject: [RFC PATCH 0/3] Add import export API for confidential guest live migration
Date: Mon,  6 Oct 2025 14:35:21 +0300
Message-ID: <20251006113524.1573116-1-tony.lindgren@linux.intel.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

This patch series is intended to get the discussion going on the APIs
needed for confidential computing live migration for firmware related
calls.

These APIs are designed to work for TDX, while also attempting to make them
generic enough such that other coco VMs could use them. While the coco
live migrations are still in flux, we wanted to see where the pain points
are in making them work similarly from the userspace perspective. This way
we can try to have at least some unification between all the solutions.

Currently live migration between the source and destination host machine is
handled by the userspace with the help of KVM. The guest memory and VCPU
states are accessible to the userspace to migrate. Userspace gets the
list of dirty pages using the KVM_GET_DIRTY_LOG ioctl().

For coco VMs, things are different. The guest memory and VCPU states are
not accessible to the userspace or KVM. Userspace may need to ask the
source and destination host firmware to package and unpackage the guest
memory and VCPU states for migration. The memory and VCPU states may be
encrypted with a migration key between the source and destination
firmware. Additionally the userspace may need to communicate with the
host firmware to manage the live migration, and to pass migration related
data between the source and destination firmware. For getting the list of
dirty pages, KVM_GET_DIRTY_LOG is still used as earlier.

To allow handling coco VM live migration, introduce new ioctl() calls to
communicate with the host firmware:

  - KVM_MIGRATE_CMD
  - KVM_IMPORT/EXPORT_MEMORY
  - KVM_IMPORT/EXPORT_VCPU

No separate VM scope IMPORT/EXPORT calls are currently needed at least for
TDX. It can be covered with the VM scope KVM_MIGRATE_CMD sub-commands.

Note that these calls are limited to cases where userspace needs to
communicate with the hardware specific firmware. This may not apply to the
service VM solutions like Coconut SVSM as it can access the memory and VCPU
states directly.

To demonstrate how the userspace can make use of these calls, a simplified
imaginary QEMU pseudo-code example for live migration is shown below:

1. QEMU source sets up migration

migration_thread()
  migrate_cmd(MIGRATE_SETUP, data)
...
kvm_arch_vm_ioctl(KVM_MIGRATE_CMD, KVM_MIGRATE_SETUP, data)
 arch_migrate_cmd(MIGRATE_SETUP, data)

2. QEMU destination sets up migration

migrate_cmd(MIGRATE_SETUP, data)
...
kvm_arch_vm_ioctl(KVM_MIGRATE_CMD, KVM_MIGRATE_SETUP, data)
 arch_migrate_cmd(MIGRATE_SETUP, data)

QEMU return-path can be used as needed.

3. QEMU source saves memory

ram_save_target_page()
 ram_export_memory(data)
...
kvm_arch_vm_ioctl(KVM_EXPORT_MEMORY, data)
 arch_export_memory(data)

4. QEMU destination loads memory

ram_load_precopy()
 ram_import_memory(data)
...
kvm_arch_vm_ioctl(KVM_IMPORT_MEMORY, data)
 arch_import_memory(data)

5. QEMU source and destination configure additional VCPU VMState

static const VMStateInfo vcpu_state_info = {
 .name = "private-vcpu"
 .put = export_vcpu_state
 .get = import_vcpu_state
}

6. QEMU source saves VCPU state

vmstate_save_state()
 export_vcpu_state(data)
...
kvm_vcpu_arch_ioctl(KVM_EXPORT_VCPU, data)
 arch_export_vcpu_state(data)

7. QEMU destination loads VCPU state
vmstate_load_state()
 import_vcpu_state(data)
...
kvm_vcpu_arch_ioctl(KVM_IMPORT_VCPU, data)
 arch_import_vcpu_state(data)

8. QEMU source migration finish

migration_iteration_finish()
 migrate_cmd(KVM_MIGRATE_CMD, MIGRATE_FINISH, data)
...
kvm_arch_vm_ioctl(KVM_MIGRATE_CMD, MIGRATE_FINISH, data)
 arch_migrate_cmd(MIGRATE_FINISH, data)

Regards,

Tony

Tony Lindgren (3):
  Documentation: kvm: Add KVM_MIGRATE_CMD
  Documentation: kvm: Add KVM_IMPORT/EXPORT_MEMORY
  Documentation: kvm: Add KVM_IMPORT/EXPORT_VCPU

 Documentation/virt/kvm/api.rst | 203 +++++++++++++++++++++++++++++++++
 1 file changed, 203 insertions(+)


base-commit: 6b36119b94d0b2bb8cea9d512017efafd461d6ac
-- 
2.43.0


