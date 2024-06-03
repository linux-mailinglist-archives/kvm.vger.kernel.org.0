Return-Path: <kvm+bounces-18677-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 12B3F8D876D
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 18:45:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C2FEC2839B5
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 16:45:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08B5D136E13;
	Mon,  3 Jun 2024 16:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DM/jGwpa"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC2747E8
	for <kvm@vger.kernel.org>; Mon,  3 Jun 2024 16:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717433089; cv=none; b=bhQvoWdT8yVNQ+8u5buEp+f8cuJTJn9HJUrIOn/FmrcQlROMywGGlA6b6DF6iIsvKg3xz/9FjlRfzhjQA6RPtC9cMsHS9ZgNiKVoDcrTSUyQ06SshoxZtyeMllsMeMpiSyKZvf4n1GuF8ikhsyaPxN9WZ+m8bbuWh5lnpnuNHes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717433089; c=relaxed/simple;
	bh=t4eoPsxvhm/UX72ypmID6dj2keloK0/DxVJPrFRAldI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=e9J7A6loOyL+kTbfV80XfDe72k+rVTPZxStJ/Px9WLcsKISNYrQI2YHiOR37B4aQaUjPMAkP89VBQlFPpUB+JHCpNqSI1pjBQzGhh1C9z/yevLZhveJNCPqHjCsp4upwkSNtD38/LrmKPdvz1uhlItChUFeh9D84hzPw42Y0axE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DM/jGwpa; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717433086;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zkJhM79a8R11avJivbxxdE1EejxLWPTC2S55x7A+4us=;
	b=DM/jGwpayWFd8NVaazWpMfkm0kqE8i79zLtEskMc+zPm/ZePknOnJJj4utt+SkFMKfSPlj
	4+Df0pGtXU9yZaWtpQ89Z2G3OqTrpSFltGg7WtFaQuvsjS25Sz79XJ1iE5inOfPvssNZxG
	Uu3iXFbDlw8jOI/wkym3JlNJGhsn1FU=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-116-buqDwvCIMOSa2r-4cNguWw-1; Mon, 03 Jun 2024 12:44:45 -0400
X-MC-Unique: buqDwvCIMOSa2r-4cNguWw-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4212e3418b1so19022815e9.0
        for <kvm@vger.kernel.org>; Mon, 03 Jun 2024 09:44:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717433081; x=1718037881;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zkJhM79a8R11avJivbxxdE1EejxLWPTC2S55x7A+4us=;
        b=rWxwNOrYUkrJdR5QI6N8qR4j7vEN+bWEK23+SLrqwGUwksZ5sQ7ZeQ2EX9Mr0fF/1v
         TdclcxejH/mtQplLoex0WVwORAIQisa8H9WsgxtDT83/L5Bx+b30BELqy5x1vqoAaLK7
         UInXhm1RqmE8ODJy3cpcPwFNsaRYjGPqoAju+jyuMnCER/FZd4J9JcAjy5RFVGsEd2wJ
         K0hoYZlEMtSg9KBNNe+zPGE4aJXH2uuPxhHMWXxiY5qJw+AUZ+estVyDQpOV/oBm5V3N
         AYuNWF/FqTPzn8rvT3R/GAj0moRnfMGi7AFT5BJBYu04CeVMRmVVDkWHoQqA5gu/6L42
         9fYw==
X-Gm-Message-State: AOJu0Yy0OQXtc8S7WiJc7i8OlyiXL33uI7zZiJE3sBeTxBqF597PELNO
	M0PbpkGqS3YYq/vfYMWZO/cJn2B7oDQTCmCnybla0dBycUO2pUgYaKAlIhNiziUsZzE5rQ/Q4V2
	5eH+YFm+xHwMi+OZ0vknh9+y404Zo31uTmRSh3sOqtRo+37PctN60xXG4R3bAlX3FWV2LCg4GxL
	FdKmTwmi3A9Og9MoKIQxg83DkL
X-Received: by 2002:a05:600c:4744:b0:420:2983:2229 with SMTP id 5b1f17b1804b1-4212e07530emr82210865e9.22.1717433081497;
        Mon, 03 Jun 2024 09:44:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFMCnI5M+sIjdtgeYl/SuU7qEpdctfImP4SJ6aepSaIJ9r0QcVVw+D6lCCYSXtw8KRc+Y06WU8alk5VEuqo8TA=
X-Received: by 2002:a05:600c:4744:b0:420:2983:2229 with SMTP id
 5b1f17b1804b1-4212e07530emr82210525e9.22.1717433081090; Mon, 03 Jun 2024
 09:44:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240510211024.556136-1-michael.roth@amd.com> <6nby33glecw46wrdws7vuokrqz4b72evrzdujcrsm6pujo62b6@xoxstkzsvwrj>
In-Reply-To: <6nby33glecw46wrdws7vuokrqz4b72evrzdujcrsm6pujo62b6@xoxstkzsvwrj>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 3 Jun 2024 18:44:29 +0200
Message-ID: <CABgObfbT_v23LbP7Mp-PfbnakHYrZ7+g3KfUA_BOnsp+7ivMYQ@mail.gmail.com>
Subject: Re: [PULL 00/19] KVM: Add AMD Secure Nested Paging (SEV-SNP)
 Hypervisor Support
To: Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, linux-coco@lists.linux.dev, jroedel@suse.de, 
	thomas.lendacky@amd.com, vkuznets@redhat.com, pgonda@google.com, 
	rientjes@google.com, tobin@ibm.com, bp@alien8.de, vbabka@suse.cz, 
	alpergun@google.com, ashish.kalra@amd.com, nikunj.dadhania@amd.com, 
	pankaj.gupta@amd.com, liam.merwick@oracle.com, papaluri@amd.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 31, 2024 at 5:23=E2=80=AFAM Michael Roth <michael.roth@amd.com>=
 wrote:
> As discussed during the PUCK call, here is a branch with fixup patches
> that incorporate the additional review/testing that came in after these
> patches were merged into kvm/next:
>
>   https://github.com/mdroth/linux/commits/kvm-next-snp-fixes4/
>
> They are intended to be squashed in but can also be applied on top if
> that's preferable (but in that case the first 2 patches need to be
> squashed together to maintain build bisectability):

Yes, I'd rather not rebase kvm/next again so I applied them on top.
None of the issues are so egregiously bad.

Paolo


