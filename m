Return-Path: <kvm+bounces-6457-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FA428322F6
	for <lists+kvm@lfdr.de>; Fri, 19 Jan 2024 02:27:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 472F528649F
	for <lists+kvm@lfdr.de>; Fri, 19 Jan 2024 01:27:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05888184E;
	Fri, 19 Jan 2024 01:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="aNjOWHXC"
X-Original-To: kvm@vger.kernel.org
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C856DEC2
	for <kvm@vger.kernel.org>; Fri, 19 Jan 2024 01:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705627640; cv=none; b=bpDkACSjn0udADLcXphIVc1+DuaAyf/RkGLJTGjRjGY60p6G+OQ1Q+FN+82QjN+Dnk80vVRn+ki/9otpQ3bKhguR3erxAL495vPNDkVSs9bBYvrp56CHdXaMOIckOPeIBcwDqiQcRl2gFWjX+x7k5NFhtvDCVX0VxCNxAmbc6lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705627640; c=relaxed/simple;
	bh=oIs2VoyVo5eys3aTQpEMmJF1mdTuSPVW1ZHPdC2hqxg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jW4FZKjZdp0EAjrjfTdlF0ci4h3Gth3DoI5pfZCEj3Zws2cKIe3jVMuZW7TDErB437MgzxHdKMVnMM9lhPOYrQjLygTcMPk7qLDmKYRGVQZ61rasfZZXJHf20ER0UGoQW/CJ+rsq9uthuI1jGEFqr3gfKMxPpshrVq/hCZgQM9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=aNjOWHXC; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 19 Jan 2024 10:26:59 +0900
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1705627634;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MEAAKdKI2s28mLXSjhbge/t2jcWXL1sSrlOeBNigut8=;
	b=aNjOWHXCrX/lkwKeCe64ksjMWHQnYhafV7LjxiqaEbtC7Rtq2OswV7y4MAuWj8a0yQmjgh
	LIHNxMfvUdAjeJ9hG0aTTuYW8VB0blGusdNjdMZYbXrerP2ioa++WAdfAkv3UDD8GsJBKI
	b0XaHXSc78GqGkDtCfcwHTBTwGgeDlI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Itaru Kitayama <itaru.kitayama@linux.dev>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, catalin.marinas@arm.com, will@kernel.org,
	maz@kernel.org, steven.price@arm.com, alexandru.elisei@arm.com,
	joey.gouly@arm.com, james.morse@arm.com,
	Jonathan.Cameron@huawei.com, dgilbert@redhat.com, jpb@kernel.org,
	oliver.upton@linux.dev, zhi.wang.linux@gmail.com,
	yuzenghui@huawei.com, salil.mehta@huawei.com,
	Andrew Jones <andrew.jones@linux.dev>,
	Chao Peng <chao.p.peng@linux.intel.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Quentin Perret <qperret@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Huth <thuth@redhat.com>, Ryan Roberts <Ryan.Roberts@arm.com>,
	Sami Mujawar <Sami.Mujawar@arm.com>
Subject: Re: [RFC] Support for Arm CCA VMs on Linux
Message-ID: <ZanP4+K/CEkhukkp@vm3>
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
 <20231002124311.204614-1-suzuki.poulose@arm.com>
 <ZZ4tsTQOKOamM+h/@vm3>
 <ec8ed5b0-5080-45e9-a4a6-e5dbe48e86d3@arm.com>
 <d47e8b8c-50e4-4ad3-8f00-cadaede1eca9@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d47e8b8c-50e4-4ad3-8f00-cadaede1eca9@arm.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Jan 10, 2024 at 01:44:45PM +0000, Suzuki K Poulose wrote:
> On 10/01/2024 11:41, Suzuki K Poulose wrote:
> > Hi Itaru,
> > 
> > On 10/01/2024 05:40, Itaru Kitayama wrote:
> > > On Mon, Oct 02, 2023 at 01:43:11PM +0100, Suzuki K Poulose wrote:
> > > > Hi,
> > > > 
> > > > 
> 
> ...
> 
> > > 
> > > Suzuki,
> > > Any update to the Arm CCA series (v3?) since last October?
> > 
> > Yes, we now have a version that supports the final RMM-v1.0
> > specification (RMM-v1.0-EAC5). We also have the UEFI EDK2 firmware
> > support for Guests in Realm world.
> > 
> > We are planning to post the changes for review in the v6.8-rc cycle. We
> > are trying to integrate the guest_mem support (available in v6.8-rc1) as
> > well as reusing some of the arm64 kvm generic interface for configuring
> > the Realm parameters (e.g., PMU, SVE_VL etc).
> > 
> > Here is a version that is missing the items mentioned above, based
> > on v6.7-rc4, if anyone would like to try.
> > 
> > Also, the easiest way to get the components built and model kick started
> > is using the shrinkwrap [6] tool, using the cca-3world configuration.
> > The tool pulls all the required software components, builds (including
> > the buildroot for rootfs) and can run a model using these built
> > components.
> 
> Also, please see 'arm/run-realm-tests.sh' in the kvm-unit-tests-cca
> repository for sample command lines to invoke kvmtool to create Realm
> VMs.

Thank you, Suzuki. I have just run the script above, again in the
framework of shrinkwrap on the RevC FVP and the jobs ran fine. I need to
go look at the lots of logs.

Itaru.

> 
> 
> > 
> > 
> > 
> > [0] Linux Repo:
> >        Where: git@git.gitlab.arm.com:linux-arm/linux-cca.git
> >        KVM Support branch: cca-host/rmm-v1.0-eac5
> >        Linux Guest branch: cca-guest/rmm-v1.0-eac5
> >        Full stack branch:  cca-full/rmm-v1.0-eac5
> > 
> > [1] kvmtool Repo:
> >        Where: git@git.gitlab.arm.com:linux-arm/kvmtool-cca.git
> >        Branch: cca/rmm-v1.0-eac5
> > 
> > [2] kvm-unit-tests Repo:
> >        Where: git@git.gitlab.arm.com:linux-arm/kvm-unit-tests-cca.git
> >        Branch: cca/rmm-v1.0-eac5
> > 
> > [3] UEFI Guest firmware:
> >        edk2:     https://git.gitlab.arm.com/linux-arm/edk2-cca.git
> >        revision: 2802_arm_cca_rmm-v1.0-eac5
> > 
> >        edk2-platforms:
> > https://git.gitlab.arm.com/linux-arm/edk2-platforms-cca.git
> >        revision:       2802_arm_cca_rmm-v1.0-eac5
> > 
> > 
> > [4] RMM Repo:
> >        Where: https://git.trustedfirmware.org/TF-RMM/tf-rmm.git
> >        tag : tf-rmm-v0.4.0
> > 
> > [5] TF-A repo:
> >        Where: https://git.trustedfirmware.org/TF-A/trusted-firmware-a.git
> >        Tag: v2.10
> > 
> > 
> > [6] https://shrinkwrap.docs.arm.com/en/latest/
> >      config: cca-3world.yaml
> > 
> 
> Suzuki
> 

