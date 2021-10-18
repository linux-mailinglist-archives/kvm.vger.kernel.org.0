Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63EC4432623
	for <lists+kvm@lfdr.de>; Mon, 18 Oct 2021 20:14:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232157AbhJRSQP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Oct 2021 14:16:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231918AbhJRSQO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Oct 2021 14:16:14 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF5D9C061745
        for <kvm@vger.kernel.org>; Mon, 18 Oct 2021 11:14:02 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id i5so5601520pla.5
        for <kvm@vger.kernel.org>; Mon, 18 Oct 2021 11:14:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rECEro2baLj28FSIARXDaUkJhvRjUYb9oi+C1vxDjLo=;
        b=ZPAAz3A6icCyKCw14of499s/0spphqJ/ZWgJwfcRlvd1YpuGt9dv/+LiPGJ3aUGt5k
         vsg8ZYbBy6vKpCEVJzyFe4zXgXmf9i2aIkh4AxCr8KvKBzX3q44m0xa7/Ky7gzmtFQSB
         LjCoZkxHQGwgLXCul1rpyttz1uGBm7xwA5Dn+LqLUZ++MgZ99fe/f08zORHFvlsYsmN/
         qAJj7rucZF08y20Q/uqNJX09z+jaNu2znWMBuYAc6BiIikLuiKMUFkitT3O0+tHxwOUh
         fAtYP+tIiS0M+5LDZU8q0dDFZWSX7msC1IW13qEF9d+vkPCgAPQlludDHGu5cFhG3fh8
         +Otw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rECEro2baLj28FSIARXDaUkJhvRjUYb9oi+C1vxDjLo=;
        b=IEd783At38wEASx5iwHxQ8WheXn7QP6jDIxd096hrOWbn+XDMC+x8opoygNtUPQUU8
         kQdiKTjYrda5+r4WuQCn0jNzsIAK9djV7Tsi9CS1XPtSAA7r3uJtFOFtlVgqiEKQ/rK0
         Zj1hG4zmE74gSUOehpDtTGk/FD8Bf17Wnw17+ncMmYUp6cZAFLzl0/qcNKVWF3tJHlZk
         YhpsYuNbfS+dEbTVITcqhJjCdjmZRDNXoRCo3IhvKXlrOg6fApzu4hH+zbF1dmUVp5z2
         3Uo7CliW50PtOu0OhRRmWFu2emd6r3uxybo3dK9MyHCF6N9qpZ287cbO9sYb2CzyMX4e
         jMwQ==
X-Gm-Message-State: AOAM533o+otGvIXrTAB0WpYOpKO1LxxyRDV6NO9nDub/jll70fZ8HXuq
        xT/uvrCI/XfgI53ZXwxNAcEVxQ==
X-Google-Smtp-Source: ABdhPJyfVUsmm094Q3ucqV7kDuWKir2JuRbECVohe1J75tjn9kE/pODxyxISBUCQtmGEf8ALRTQmnQ==
X-Received: by 2002:a17:90b:4a47:: with SMTP id lb7mr515308pjb.192.1634580842194;
        Mon, 18 Oct 2021 11:14:02 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id m28sm13860556pgl.9.2021.10.18.11.14.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 11:14:01 -0700 (PDT)
Date:   Mon, 18 Oct 2021 18:13:58 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        David Stevens <stevensd@chromium.org>
Subject: Re: [PATCH] KVM: cleanup allocation of rmaps and page tracking data
Message-ID: <YW25ZiTE1N6xS4FN@google.com>
References: <20211018175333.582417-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211018175333.582417-1-pbonzini@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 18, 2021, Paolo Bonzini wrote:
> From: David Stevens <stevensd@chromium.org>
> 
> Unify the flags for rmaps and page tracking data, using a
> single flag in struct kvm_arch and a single loop to go
> over all the address spaces and memslots.  This avoids
> code duplication between alloc_all_memslots_rmaps and
> kvm_page_track_enable_mmu_write_tracking.
> 
> Signed-off-by: David Stevens <stevensd@chromium.org>
> [This patch is the delta between David's v2 and v3, with conflicts
>  fixed and my own commit message. - Paolo]
> Co-developed-by: Sean Christopherson <seanjc@google.com>

Checkpatch will complain about a lack of 

	Signed-off-by: Sean Christopherson <seanjc@google.com>

> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---

...

> +	bool shadow_root_alloced;

Maybe "allocated" instead of "alloced"?
