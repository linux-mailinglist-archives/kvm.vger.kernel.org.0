Return-Path: <kvm+bounces-27515-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 390769869F3
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2024 01:55:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 73FA5283864
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 23:54:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92BF91A3BCA;
	Wed, 25 Sep 2024 23:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IZ6BqOSy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 879CD15852E
	for <kvm@vger.kernel.org>; Wed, 25 Sep 2024 23:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727308488; cv=none; b=XqRHxFBBor/pFTTt+vOvpNq26zJDf//KLmEZA/iIDRZw3dz0QaTCrjgtoqPgUELZZBrFbWamEgCgsctZ/qbQtyNYg/JXJzZ0vNiwCRstfJtO+l3ESgfrwsGEf5r2mJ59else3jspR1CXCNv/XGPNrDfO2nYLlU5K6Pi5AYiKDEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727308488; c=relaxed/simple;
	bh=gOwSyLGNGcndIHcc19zgCHlgwnw0OJizgjnZ1/eV1cM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bfs1acPbc9NB6mPbK0YnRts5tpWFo/DWKupnrB3/k+0jzo8hEIkZisrdEAs8Kt4Bt4r40ihwiTsMWoEQS0kEkEDyfc6BgwWGgejwqYykIO8BOFAbq627lnMIs6hnk++cskME0ADYrZT5GAJGGni9duz4iqKJc0qE4WFeAQjnih4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IZ6BqOSy; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-2e078d28fe9so328915a91.2
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2024 16:54:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727308487; x=1727913287; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BPIrG48JYLdoIFjq+YQPVxvOebeKVybr78OCt6RYK3Y=;
        b=IZ6BqOSyEWoe2XWfiVxXD+u5O6+ndK1OTXRv1RB0b3SP3hgFOojNGegNcOusUtQBn4
         2UZLFwqiPg3ROq8lhMYPPfIa6ZQ34Yn0REUHrA4pSjEB3AcjOrVzO1JDVidpRtTGtQRq
         NZ+1lrwtr0VMDmPAwPoj04MhoZ3DyIMwgTNrbnAxK80aDiE7auMjXlG0cUGt6r9IJrld
         A6iCfjQS8gMvAhsyfLgy6SXHP3E0n1avwYZc1zlSpZO9n3qeD/0wUaBpoZwRjRvKc/Uz
         CTspf8ffevQU7EuFcye1WSwUZF5fgu2Hket9XgCe3MUOQwv6uXMwZK4/msgudYD+SuMB
         D2Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727308487; x=1727913287;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BPIrG48JYLdoIFjq+YQPVxvOebeKVybr78OCt6RYK3Y=;
        b=k0D+XJ7Ju5TyWyCDOFpW9CwV3wFLNSHZ5Ca4aVOdyD9rp5vi4SNoCLwf0IK17ry0pk
         iCms5sAzv+Cu87nTafg3Nirqk0vMOzEt9zOSS9sh5KBTNSXRQziMKXjOzM9j0Nm0mUVt
         XrXITL038fF/j9gGq7ZQhasPnDDH9an57nrX3L5VqcC7p9HKmyY8I7OR+DNpO9JAO43G
         XdNcgUJp94n/nDqZMoBMhZMCTdy03DBCjwq5dbb7Kwlg6kPHs8cT3IZAsPZogLjGb4tL
         2IYO4mbLM7gFCWDrERo3qD5pjINGom5NvplXGdvksmQYznAusBR8p2nwOX87vGBjN3yH
         iwUg==
X-Forwarded-Encrypted: i=1; AJvYcCVPQXCbW4lEPYE7ZFcBNrT9D2P0vyj05Oi9CPFJuyMSnwjB3+DswyY2KNw14A3sEsv7Vfo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw3H+GehuIHLN5hfLrTFU4pSdJiiLT9ILWcPNakkupgS734uAPd
	CcWWb2PWVY63C3oXPblbUUaUWuFPvOyrncn1qrUFQJl7a+dPK6HZG5/AQHpRsg==
X-Google-Smtp-Source: AGHT+IGcE3X6C1/MkwIoK7n5+4anKnUm5PMfHFhhK0bQSFUAAbP5pQ+ofyEhXIkKahGjfUidMIedkA==
X-Received: by 2002:a17:90b:1c11:b0:2d3:d728:6ebb with SMTP id 98e67ed59e1d1-2e06ae21775mr4852142a91.5.1727308486443;
        Wed, 25 Sep 2024 16:54:46 -0700 (PDT)
Received: from google.com (46.242.125.34.bc.googleusercontent.com. [34.125.242.46])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e06e1b8e25sm2063439a91.13.2024.09.25.16.54.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Sep 2024 16:54:45 -0700 (PDT)
Date: Wed, 25 Sep 2024 16:54:41 -0700
From: David Matlack <dmatlack@google.com>
To: Vipin Sharma <vipinsh@google.com>
Cc: seanjc@google.com, pbonzini@redhat.com, zhi.wang.linux@gmail.com,
	weijiang.yang@intel.com, mizhang@google.com,
	liangchen.linux@gmail.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: x86/mmu: Change KVM mmu shrinker to no-op
Message-ID: <ZvSiwc9UFFVIh8Kb@google.com>
References: <20240913214316.1945951-1-vipinsh@google.com>
 <20240913214316.1945951-2-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240913214316.1945951-2-vipinsh@google.com>

On 2024-09-13 02:43 PM, Vipin Sharma wrote:
> Remove global kvm_total_used_mmu_pages and page zapping flow from MMU
> shrinker. Keep shrinker infrastructure in place to reuse in future
> commits for freeing KVM page caches. Remove zapped_obsolete_pages list
> from struct kvm_arch{} and use local list in kvm_zap_obsolete_pages()
> since MMU shrinker is not using it anymore.
> 
> mmu_shrink_scan() is very disruptive to VMs. It picks the first VM in
> the vm_list, zaps the oldest page which is most likely an upper level
> SPTEs and most like to be reused. Prior to TDP MMU, this is even more
> disruptive in nested VMs case, considering L1 SPTEs will be the oldest
> even though most of the entries are for L2 SPTEs.
> 
> As discussed in
> https://lore.kernel.org/lkml/Y45dldZnI6OIf+a5@google.com/ shrinker logic
> has not be very useful in actually keeping VMs performant and reducing
> memory usage.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Suggested-by: David Matlack <dmatlack@google.com>
> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> ---

Reviewed-by: David Matlack <dmatlack@google.com>

