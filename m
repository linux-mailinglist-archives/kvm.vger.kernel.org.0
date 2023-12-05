Return-Path: <kvm+bounces-3427-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BE6A8043E7
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 02:18:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0A0231F2130F
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 01:18:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A95FE1384;
	Tue,  5 Dec 2023 01:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KgwornHg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EEFCC9;
	Mon,  4 Dec 2023 17:18:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701739115; x=1733275115;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ANNzQJqNaKlCYsNCLNZpFEjS7XvSSIJhQXWDN5zdWnU=;
  b=KgwornHghuqAnm+4GbkGOuSNQoO782OkqAnav3KrvGhjiKPpHwmKITtk
   ycH55oqNXrw/LTEmx8NGtb0dmWUh+1n8s9P498k2SBkm5269CBC8RppCb
   Hmmv60MmvKQWn1v9l2/r2uAxiKpYM6wPp/VtXL0IE3l4ETP9/yLCmqcNh
   m3A5f81+u042bb3vAbN68mgYOxPhX6ulxc4XkiiTzWB3sCLq13FpzUOL3
   R+FmaKaudLn/OaD1Wd3Coirstf+nJafUZ04W3U5surFcdazEDalodBwMu
   Dl3YhPbepOu8uCImqZxE2CVLUvsif0ydRdDBT8RnN0j/aeRYIWSnHK28Q
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10914"; a="390975781"
X-IronPort-AV: E=Sophos;i="6.04,251,1695711600"; 
   d="scan'208";a="390975781"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2023 17:18:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10914"; a="841254453"
X-IronPort-AV: E=Sophos;i="6.04,251,1695711600"; 
   d="scan'208";a="841254453"
Received: from allen-box.sh.intel.com (HELO [10.239.159.127]) ([10.239.159.127])
  by fmsmga004.fm.intel.com with ESMTP; 04 Dec 2023 17:18:23 -0800
Message-ID: <ce0eea97-909b-4be2-b1fe-2d3021281e7c@linux.intel.com>
Date: Tue, 5 Dec 2023 09:13:50 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: baolu.lu@linux.intel.com, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
 Kevin Tian <kevin.tian@intel.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Nicolin Chen <nicolinc@nvidia.com>, Yi Liu <yi.l.liu@intel.com>,
 Jacob Pan <jacob.jun.pan@linux.intel.com>, Yan Zhao <yan.y.zhao@intel.com>,
 iommu@lists.linux.dev, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 12/12] iommu: Improve iopf_queue_flush_dev()
Content-Language: en-US
To: Jason Gunthorpe <jgg@ziepe.ca>
References: <20231115030226.16700-1-baolu.lu@linux.intel.com>
 <20231115030226.16700-13-baolu.lu@linux.intel.com>
 <20231201203536.GG1489931@ziepe.ca>
 <93a57e63-352c-407c-ac3f-4b91c11d925d@linux.intel.com>
 <20231204132732.GM1489931@ziepe.ca>
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20231204132732.GM1489931@ziepe.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/4/23 9:27 PM, Jason Gunthorpe wrote:
> On Mon, Dec 04, 2023 at 11:46:30AM +0800, Baolu Lu wrote:
>> On 12/2/23 4:35 AM, Jason Gunthorpe wrote:
>> I am wondering whether we can take patch 1/12 ~ 10/12 of this series as
>> a first step, a refactoring effort to support delivering iopf to
>> userspace? I will follow up with one or multiple series to add the
>> optimizations.
> I think that is reasonable, though I would change the earlier patch to
> use RCU to obtain the fault data.

All right! I will do this in the updated version.

Best regards,
baolu

