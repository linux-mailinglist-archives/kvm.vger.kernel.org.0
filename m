Return-Path: <kvm+bounces-11234-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 45457874555
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 01:54:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DAF7CB23587
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 00:53:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86A6A4A33;
	Thu,  7 Mar 2024 00:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TtcZ+CDC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 665BE29B0
	for <kvm@vger.kernel.org>; Thu,  7 Mar 2024 00:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709772827; cv=none; b=bJz516UGDjx3TsJBNIl1nlpu0IqLys4YhwBCJr+fx0qPuNVjK75yrl7ZgZgKWVEuRQD3t7zbS6VSApTtRxh2OgxUeafVGMnE2lbulqJX55ObxmtXfF2aRy8wyz1m8cj1Qiyup+2gQUafo7xs8JjjAcWlrt1poQqoJsMtAxCxX5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709772827; c=relaxed/simple;
	bh=kL//jgPDiFCIqsbXAwIf6piqMB/VEIeEGVOQr6c+ZM4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oC+3gq2/AtjmYgF78mRdANJircoGpYKrp7eHbtbpz9PcTbMkhAJsIQvoTZOfunT11JY7ju+DwTdFLKq2dN0FdQWxobZI5suGlieMcT0nIbR90C3F7TtJpuvoZX160x29g6FAL3O3yApV7oSUi0I+VrV1bluNDleWObW93r3TB60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TtcZ+CDC; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-5e42b4bbfa4so213876a12.1
        for <kvm@vger.kernel.org>; Wed, 06 Mar 2024 16:53:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709772826; x=1710377626; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XTftWjXZw94q4+F4f8emI0lnL+iz/nWWwkVmzB+hhvg=;
        b=TtcZ+CDCKB1Vx+33z3GuAGYZCgGj59wyGBC82V6x4qn7ROFFNPTs1N7BIatU97Kkjf
         DLvisLUDt/ahDaOs0if6mBGQf/l9u1NirKnivUyjIg1uDCT0ujqGoL/lF6zQf510/LSH
         Ii26hgHk7X8iPgbUS35oNF+vbcbDZOTDnSOZvfFUC9x4/ZHTv8Li0k13YTRr8WjKQp0g
         VoySSAS60qGVnwJR4CBt+eXOZyi5Pla55k6CT5vpsrIhs7YgFbeXu/aZ6n0xAXpRAdsU
         MceSh767nr9kpR5ADVk9Ksh8KAQKLwkDOjivoF4++LJKlzNoTxLVGGDBGG0qkRa3Cwv0
         4lzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709772826; x=1710377626;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XTftWjXZw94q4+F4f8emI0lnL+iz/nWWwkVmzB+hhvg=;
        b=mwzgqlxs9wvqiU4W6DthrpHBgk9sgTFPOl4gpptR8VLjy/EZmoad3AIRPm6fKTNl0R
         NiZ6L07jmR9a+VOLEdkzjjNlB6xQ2O29Cim5VMaL0D/PEEigLWiXpMeYyrsoBpsdiHXa
         bRRhF/QJDqLPTWDOuNsLIaaFoS9KzoXVCfcpum9nRav/f6SIoUHORwS6vCGIZNC2EtGH
         eIdHJPDI0GPyKala2l4yUlrw6A425dAEBwYN86Zx4uIh2QysJFSe3AcA0RxjKJeuoD7s
         xPQAV7jYyCBq9E2avnxIONTSitbUdUv3LgyIyQcbNV1yngW5Ww8E7S3ugf0YaCRMW9ap
         +jwQ==
X-Gm-Message-State: AOJu0YwD7gRmBgglMuk2WqgOhfI8ynY+RLfFIxzYmdkYTilfWWGeTnmk
	2eVAHUQXexxY1EwITcfcLeOW9UY+ObKoa8/+oNzbscBOcNcAwOi0WXE2yCnn0Q==
X-Google-Smtp-Source: AGHT+IGAn1fdYlbImKRNZc/GrCx7mEmPc71V+M4i5UOui2PzT3x/GBReTpx2caiH9qy7SvCNMsgKBQ==
X-Received: by 2002:a05:6a20:1a90:b0:1a1:44f9:cbf3 with SMTP id ci16-20020a056a201a9000b001a144f9cbf3mr5188857pzb.57.1709772825580;
        Wed, 06 Mar 2024 16:53:45 -0800 (PST)
Received: from google.com (61.139.125.34.bc.googleusercontent.com. [34.125.139.61])
        by smtp.gmail.com with ESMTPSA id m2-20020a170902db0200b001dcf91da5c8sm9398420plx.95.2024.03.06.16.53.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Mar 2024 16:53:45 -0800 (PST)
Date: Wed, 6 Mar 2024 16:53:41 -0800
From: David Matlack <dmatlack@google.com>
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, isaku.yamahata@gmail.com,
	linux-kernel@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Michael Roth <michael.roth@amd.com>,
	Federico Parola <federico.parola@polito.it>
Subject: Re: [RFC PATCH 0/8] KVM: Prepopulate guest memory API
Message-ID: <ZekQFdPlU7RDVt-B@google.com>
References: <cover.1709288671.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1709288671.git.isaku.yamahata@intel.com>

On 2024-03-01 09:28 AM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Implementation:
> - x86 KVM MMU
>   In x86 KVM MMU, I chose to use kvm_mmu_do_page_fault().  It's not confined to
>   KVM TDP MMU.  We can restrict it to KVM TDP MMU and introduce an optimized
>   version.

Restricting to TDP MMU seems like a good idea. But I'm not quite sure
how to reliably do that from a vCPU context. Checking for TDP being
enabled is easy, but what if the vCPU is in guest-mode?

Perhaps we can just return an error out to userspace if the vCPU is in
guest-mode or TDP is disabled, and make it userspace's problem to do
memory mapping before loading any vCPU state.

