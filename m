Return-Path: <kvm+bounces-51756-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B45B2AFC827
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 12:19:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8D0837B13AB
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 10:18:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E03D126A1AF;
	Tue,  8 Jul 2025 10:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iS5kUD4y"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63586267B19;
	Tue,  8 Jul 2025 10:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751969975; cv=none; b=jchrhzLqOBXYDb1jBjxVYEHGkzKnmif/wGsXtC8PmXMxlZUeBACmMIc6UFyvpMDFtYoB3dOq29qSc3wVnd57F7klzSb1KTn2J59fvpiTzmfDFJg33fkXX4yguY/cqsh7Z5vaGzc8ttN/ZF72ou7d6CrLBUMTa7nWSACQ171qEQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751969975; c=relaxed/simple;
	bh=RqH3W+vAv3syVjj6kukRERKu2daJsd+9JEUGyf1KgII=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hx9tcTnMVvjfP2RjJ9nuaKPzu8HiA7oZbd3hzlv4VVM9/R6xBDxUHuHzsMo8cw0N5H5Lm0EUboNGqYMZ8uUrur0X4GtFPvIrckI5vJsF9EBt4olqsAAHgke9+r7sZ1cJ6QrOn8RGUvn+pvKn9wgsxs8qUz7f477ImZMrPy99p30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.helo=mgamail.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iS5kUD4y; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.helo=mgamail.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751969974; x=1783505974;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=RqH3W+vAv3syVjj6kukRERKu2daJsd+9JEUGyf1KgII=;
  b=iS5kUD4yw8SZeDF30alMNavu9JEoTVtu3SI/jVN+MaT47On6x4zjyRpy
   kd+TB6ZX/hhisY8ru43OtHvWtghvXOWIhtiFEOG+YIcv058J7UVQt/qD4
   +NKWF+bmvZ41nlVqYswjiDVJJ2vNvoQ8fnfs4cT6MdMeawfdSpOGTBdNQ
   AoVWsM5D9J40SaqT/UU6osL9Qw6UZncIH+bHPz9h091JWAu+Y7iptQ7x8
   XPLml7d4HICTPxu/Hrfi0zu+A8FO1Jaau1LoLG2noVktS/l2EH7r6+552
   2u2DJ93QBggUZKZkVRAsJqrojqaK5vxlsjJm0VY5/Dv5IOu8E1+VYQQRt
   Q==;
X-CSE-ConnectionGUID: 7cNWI8j9Reyky/OxtarbvQ==
X-CSE-MsgGUID: Nfd6Gm/NSw+Md8Ff+nQMkQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11487"; a="79632825"
X-IronPort-AV: E=Sophos;i="6.16,297,1744095600"; 
   d="scan'208";a="79632825"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 03:19:33 -0700
X-CSE-ConnectionGUID: u51uWat7TsCTYuPwysrZqw==
X-CSE-MsgGUID: 9Hgg5xOhQo6lu8+uAdXpdA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,297,1744095600"; 
   d="scan'208";a="155952280"
Received: from black.fi.intel.com ([10.237.72.28])
  by orviesa008.jf.intel.com with ESMTP; 08 Jul 2025 03:19:29 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id 8AFAE157; Tue, 08 Jul 2025 13:19:27 +0300 (EEST)
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Dave Hansen <dave.hansen@linux.intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-coco@lists.linux.dev,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH 0/3] MAINTAINERS: Update TDX entry
Date: Tue,  8 Jul 2025 13:19:19 +0300
Message-ID: <20250708101922.50560-1-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The patchset updates the TDX entry in MAINTAINERS:

  - Add missing TDX files to the list, including KVM enabling;
  - Add Rick Edgecombe as a reviewer;
  - Update my email address.

Paolo, Sean, are you okay for TDX KVM stuff to be covered by the same
MAINTAINERS entry?

I don't see a reason why not, but I want to double-check.

Kirill A. Shutemov (3):
  MAINTAINERS: Update the file list in the TDX entry.
  MAINTAINERS: Add Rick Edgecombe as a TDX reviewer
  MAINTAINERS: Update Kirill Shutemov's email address

 .mailmap    |  1 +
 MAINTAINERS | 15 +++++++++++----
 2 files changed, 12 insertions(+), 4 deletions(-)

-- 
2.47.2


