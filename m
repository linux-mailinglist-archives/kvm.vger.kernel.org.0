Return-Path: <kvm+bounces-20662-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 127B491BBBF
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 11:43:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BB7C11F21196
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 09:43:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A9B51534E6;
	Fri, 28 Jun 2024 09:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AK90lhX2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D1AC13FD9C
	for <kvm@vger.kernel.org>; Fri, 28 Jun 2024 09:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719567778; cv=none; b=e67KkXuEBnU/KTH8C5jxzHzWY1uqSA5nRYPRn6WnSm6qKF/n23G96WUBMKnIRoBNJHP9WP6qxOGg5GNX+CQtvZnD/mc4J1HdIgF6yTA8KnlFU1F8jvCCtBjamny0+ETK0F+CQte+TeeDMBNjTkk7NXlg2zK3BLxNThbsv4MixjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719567778; c=relaxed/simple;
	bh=6ha5d54e0GcaLUjxcEBPjrez8GMnnT78HmshwcpSGjw=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=dt9I4/XpydZZ90xffeoR67omF8wWckrPnN16dGPxkoGzQbYqgK0Z5i14tkaRB5yZTSaEFENv4y60kKzbglfoOV+7D1i5+d1Dp3+FuLA3meYihYHrLnKXvSmPL7K8qpxZ5JdqPf6XyKdCmOHCjTsrnsp7L6semw/Ox7lLHg8hS3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AK90lhX2; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719567777; x=1751103777;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=6ha5d54e0GcaLUjxcEBPjrez8GMnnT78HmshwcpSGjw=;
  b=AK90lhX2yN1XsmymbOHwN5knED/5i492xe/Zcau5G3LPUEY46MQBsdRU
   sZb9l5MWuTnga4U/qfczPBR1MTx2kpYbgd2GVlhekGjJ8Ke8T/N925p0z
   3/dBv3UBBC0JDOxNmKIpnRJXBhRvPURpqmH6ggARwdSjhwUHg9YHfMfPm
   X89e/Yp/8gBc/wOp7VLA5amLFkxuTFAy+AYGzc6/I1jp95V/636UOgD0J
   i/00fUSpPmDsGrsVNz5T0KH29zNamr0gVGbKf4qWt2L18jBbjnZpZsAJO
   siq+Z31UxPDWtNMxumEttnCKz6iTgbqHpqCsrRU0orpptzgiabgVx+vQD
   g==;
X-CSE-ConnectionGUID: LE+xYzQUTJSngSIGG9YICA==
X-CSE-MsgGUID: e7Q+APFOTHCS7tzdwF5d6g==
X-IronPort-AV: E=McAfee;i="6700,10204,11116"; a="27429179"
X-IronPort-AV: E=Sophos;i="6.09,168,1716274800"; 
   d="scan'208";a="27429179"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2024 02:42:56 -0700
X-CSE-ConnectionGUID: NHSd8AGmRbGgTl1XkGYuYg==
X-CSE-MsgGUID: 4c1Ho1dESNiuqqkjBBEE4Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,168,1716274800"; 
   d="scan'208";a="49162940"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.125.248.220]) ([10.125.248.220])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2024 02:42:53 -0700
Message-ID: <8e2bbc1a-f014-4fd9-bbb9-c6e5e47595f3@linux.intel.com>
Date: Fri, 28 Jun 2024 17:42:51 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: baolu.lu@linux.intel.com, alex.williamson@redhat.com,
 robin.murphy@arm.com, eric.auger@redhat.com, nicolinc@nvidia.com,
 kvm@vger.kernel.org, chao.p.peng@linux.intel.com, iommu@lists.linux.dev
Subject: Re: [PATCH 2/6] iommu/vt-d: Move intel_drain_pasid_prq() into
 intel_pasid_tear_down_entry()
To: Yi Liu <yi.l.liu@intel.com>, joro@8bytes.org, jgg@nvidia.com,
 kevin.tian@intel.com
References: <20240628085538.47049-1-yi.l.liu@intel.com>
 <20240628085538.47049-3-yi.l.liu@intel.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20240628085538.47049-3-yi.l.liu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2024/6/28 16:55, Yi Liu wrote:
> Draining PRQ is needed before repurposing a PASID. It makes sense to invoke
> it in the intel_pasid_tear_down_entry().

Can you please elaborate on the value of this merge?

Draining the PRQ is necessary when PRI is enabled on the device, and a
page table is about to be removed from the PASID. This might occur in
conjunction with tearing down a PASID entry, but it seems they are two
distinct actions.

Best regards,
baolu

