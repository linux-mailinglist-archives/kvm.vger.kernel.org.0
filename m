Return-Path: <kvm+bounces-53784-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E4180B16D99
	for <lists+kvm@lfdr.de>; Thu, 31 Jul 2025 10:34:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 529D51AA7CCD
	for <lists+kvm@lfdr.de>; Thu, 31 Jul 2025 08:34:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2108F29DB96;
	Thu, 31 Jul 2025 08:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IF0mrk5R"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D837D2957AD
	for <kvm@vger.kernel.org>; Thu, 31 Jul 2025 08:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753950862; cv=none; b=hr8+YhdKMsHmgNYIF6CmtXG16YUGY1YkHYunKXgImrXxr4OI+t2fdcZ2fCyghONPy7lRlyDPT9bdIQBczCj0ymYixai7Zh2ETviW/VkQuU0sKkASiRlwKLgF9ANgnM2lAGZPsJVSbwaQjYJz9d5uqMYioY/1GyItZkyKDx0lqXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753950862; c=relaxed/simple;
	bh=eiNYedotPctc6xPTtf1N6xVN29fIlNTNoGPInQPwrIg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KOy7KTx7yXlDVyLJiKi2rPNayYxar73wbYtSgP69c8Eq465mFfbGbSaYwNtXP2YBGSdJSl8fGDkdGor55sG51sWPWjun2KJcDqEvVk0SzHOnWHAxv/EiLpWH+Fvj2FxhFV9r+qEtKXOkvia+AaorL91YTjkrDwnc4KBQVSOhxlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IF0mrk5R; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4ab86a29c98so209621cf.0
        for <kvm@vger.kernel.org>; Thu, 31 Jul 2025 01:34:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753950860; x=1754555660; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=eiNYedotPctc6xPTtf1N6xVN29fIlNTNoGPInQPwrIg=;
        b=IF0mrk5Rist5J0IRks9DJHDrtbC63bkqftZMIJ0sRIChBfQNu9Mdd2/iN87vMgSYNO
         h2g+AAVjQt1XvGpEUFiKe+PtkqdZYPQroX6hreZIz8qWgHt0HzL+aHkMAVnhbesktTO3
         VUJBao3rZfbfQaoMzN7GPjVddX/BsqQvq6F02DzGSyh8H+asWkBGT8Ij0pajkpC5udvR
         VB8mFiMj1UN63IPYWIEU6AYwfW802j+GNpFvHcy2BkC3NFCQdJYXYAflsODOnMExhoa+
         0Yhb+PzbzcgxEpT7YRgCe1JPhMxzYnmOfHLOWviAcG0KJiJw8tsQeL2OLj5Z2rS6T7Ms
         HsoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753950860; x=1754555660;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eiNYedotPctc6xPTtf1N6xVN29fIlNTNoGPInQPwrIg=;
        b=V89/i6MhpYg5KGHoI4IqMJKViCPbB8Swa5TH1htptJAQTyFBKe8CAgKEhe/+TvFgX7
         kOTxcqmuz8+WU07qVWRyupYCOtkQZVC6KZ9eCq2CsKJgP1yw8zu1ARsz5EMW3ACT1yXu
         3sHGMuSNXVD8erskKN7cetuspL5lh6mDpe3/41jclaEYyVMeRZo9ziJRJGc2/e/wiVfk
         kxBo//+B8J84NxrG415YV/Z2lqlzr7S9mzREeZ6bdUGtGtBS7RMJGwtC/4T5HtmZVCqp
         5AjxFLTbtvznGEAHmeW6gutskqhpMrul+f2dZUHKqnFs7uCrCNIH25XVWn0kgULuGVB5
         v+lg==
X-Forwarded-Encrypted: i=1; AJvYcCXnh8UmlWuefpC2W+g1JQqmXhDmeiLwE/qAT6OX4jKaX8mDpqW1pD3kc+O78uWH5RPCNwE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzIgK8msJDMrSadUbv0ZgjUqNqFZcu1gNLfrsipONFwF1Ks0evp
	w660rXd68BbLU/ril1p4rz3g3dfA+Y0QsACPbDzgKT8Xtk+NzEauMI8j6aqA1DKwfaqFKoyrIQv
	c/tZpi85WE3Lu4NH4rd/aJbp7Md83K8Ed56xTnXjd
X-Gm-Gg: ASbGnctckTPj3vOUEGd8VIbod+M6PFkaFZpapG8VVIYt7LsuJgFD7upglQC+YRKpGCC
	9nfljE/soLxNbPbwE9hfn8inaHQVbMS7c3yhLUTVLCWqkBKAVZ3zTiFELcu03ut4slKhxLHY0GL
	MMVWvbEaZzkKwxFUe7m7FTziOlk4vIWmRe57RoSjz4Oc+NHsxUi/dmZr/ZpqpRBdnuV49ecE+n7
	UNdctZWIpUayRndIA==
X-Google-Smtp-Source: AGHT+IHWSj7+ppidqQQ7crIyrSg2wcIE/rWj46ZOv/ucXGZB3xZ7fB2xhdup8ZybMJXt3sd69EoqALJyiMp0TePdZrs=
X-Received: by 2002:a05:622a:9:b0:4a7:e3b:50be with SMTP id
 d75a77b69052e-4aeeff8952dmr2421461cf.16.1753950859428; Thu, 31 Jul 2025
 01:34:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250729225455.670324-1-seanjc@google.com> <20250729225455.670324-13-seanjc@google.com>
 <CA+EHjTwuXT_wcDAOwwKP+yBetE9N46QMb+hUKAOsxBVkkOgCTw@mail.gmail.com> <c320b7a3-bf75-4f9e-bd72-4290fd9fe9d9@redhat.com>
In-Reply-To: <c320b7a3-bf75-4f9e-bd72-4290fd9fe9d9@redhat.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 31 Jul 2025 09:33:42 +0100
X-Gm-Features: Ac12FXzoE81EGQG0C5ZbrL6pv7Gwfmxe6c2Z4n5qEJHhSLSLb8R4m4jCH0y1OFY
Message-ID: <CA+EHjTx8KiDS+WcB9gpWaKtmEaC40gdE1ZDaMJydHfMJLVLbwA@mail.gmail.com>
Subject: Re: [PATCH v17 12/24] KVM: x86/mmu: Rename .private_max_mapping_level()
 to .gmem_max_mapping_level()
To: David Hildenbrand <david@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>, 
	Gavin Shan <gshan@redhat.com>, Shivank Garg <shivankg@amd.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Ackerley Tng <ackerleytng@google.com>, 
	Tao Chan <chentao@kylinos.cn>, James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 31 Jul 2025 at 09:29, David Hildenbrand <david@redhat.com> wrote:
>
> On 31.07.25 10:15, Fuad Tabba wrote:
> > On Tue, 29 Jul 2025 at 23:55, Sean Christopherson <seanjc@google.com> wrote:
> >>
> >> From: Ackerley Tng <ackerleytng@google.com>
> >>
> >> Rename kvm_x86_ops.private_max_mapping_level() to .gmem_max_mapping_level()
> >> in anticipation of extending guest_memfd support to non-private memory.
> >>
> >> No functional change intended.
> >>
> >> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> >> Acked-by: David Hildenbrand <david@redhat.com>
> >> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> >> Signed-off-by: Fuad Tabba <tabba@google.com>
> >> Co-developed-by: Sean Christopherson <seanjc@google.com>
> >> Signed-off-by: Sean Christopherson <seanjc@google.com>
> >> ---
> >
> > nit: remove my "Signed-off-by", since I'm not a co-developer, and instead:
>
> The patch went "through your hands", right? In that case, a SOB is the
> right thing to do.
>
> "The Signed-off-by: tag indicates that the signer was involved in the
> development of the patch, or that he/she was in the patch's delivery path."

I see. I thought it only applied to the current re-spin.

In that case, sorry for the noise! :)

Cheers,
/fuad

> --
> Cheers,
>
> David / dhildenb
>

