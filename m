Return-Path: <kvm+bounces-45142-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 887C6AA629F
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 20:07:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EE1C0179E29
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 18:07:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8574D21E098;
	Thu,  1 May 2025 18:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JUJmckzL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FB9A11185
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 18:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746122866; cv=none; b=cZaZFfHNMc76O0vgVkHTLGR7Aw5uCYl21FYW+vvbAqnDi/NaJHYFIju7CXdyos9aQHJJRp/GuN/aVmKE18a5uBPuqcG56szcL0Nx0zI5Bu/DqG/hJzMIeQbuXcxG0t+WIkgwwH0T9CgYV/V/h/V2RVFzsUzx9ErB+TJakQC49Mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746122866; c=relaxed/simple;
	bh=jTgQ+pjYfcSBsuzw5PElBx1zE+lKC72gK06Ty+QDluw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=U6Fam16ZZlOT5Dn6f7QH4lwtxxwtg/gimfbUX01oX5mp/CR0IczMDgz0vhkRE2GS03y7Eqje/1zG2hawJSuPPx8yPdUkkJBkgaBIGRNOnYnFwJ6RW4kMvNGtHA5NQ1f+tFeuqqdkukrSRcX8VHb25Jiw9VvadAZwFprgiaqSiRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JUJmckzL; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-72f3b4c0305so1422379b3a.0
        for <kvm@vger.kernel.org>; Thu, 01 May 2025 11:07:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746122864; x=1746727664; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WoZn80XDTzxcS+MRERpMtYIBFo9FfmJttCrRhIdzvtw=;
        b=JUJmckzLOpASQoyjnbw+3U5ykDQLz3CEN43tMXxdHPye0oNeJDG6Vn9eVFAwWfvw2+
         ba2WteqPhszDY1xdZtF5c4c3zDRGzVqgxm8g5dGo9Tm3OsL8msKKgUan/MbhtuCDpfBz
         +1ch3DnGOVEogTahcxyXfAe6k7w4x8n9pKsAx6MRGPlNggKxQo6GegQKQwsDt0kIdQMa
         I0aGITmSQ/dyLMa4V55lHr5VO4uvTb0/vX9FN8NiGC6vZDuVwyo0M01qHgLxZ1V54fIG
         gurRXUWc6YpAz/7YkKUODYvuYuZEQ+WmSbsHFJbGEoYKj74+WsN8DCC+wS2CjOUuKRt4
         N8FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746122864; x=1746727664;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WoZn80XDTzxcS+MRERpMtYIBFo9FfmJttCrRhIdzvtw=;
        b=haSY9rFIXKH0/4ZoBvcwsY9HF3yjirPLNYfuhCoPp0iV7u4IMe6oaR5W80lZsDFo8d
         Tyu+YHLqd2DxH6UNXwWu1x1o8Xz9pYy4UM39ek/rPXs+CCPWgpIsTBuPE4wnJHtfeiLW
         6UsT5Y9GN4zExN/Iry0snruwps4Zc+FoxOUqQB89ZreHAO7ykRDva5791GaOOkLRKS4Q
         EpYP5u8QRLYrEIeMQpM48QSC2elwupoqaQx3ff9ElAP26QHsdWi4gazWKLB751JxeysE
         OaB6Fr7AmLVAWlbVt7AiBq8eNaeh/jUnmVPUUw15tN3ZxAGFpovxMEY9UZ3srSwzmj2I
         bRWg==
X-Gm-Message-State: AOJu0YyZRoBIsdtEvRLdffd28MUSZKCOvUBbKO0z4DFKy/TYTGrxHtre
	toMIdFrmKHdwPzsn1AGOuUusHubhf98hV1AZ8z0FRvPnH5yamtyMlp5+u3nruuzLnzrc0uliZh5
	2dSfCc0GIl0J7ZlRZmyzmqQ==
X-Google-Smtp-Source: AGHT+IFSEd8DShm65Tldw7L7OZBNet0Dnja4TVYq09DvLlZaLwsIOyPe7C13BFuECacWjVmfh8ZAMUqyxGggUzirQQ==
X-Received: from pfjf5.prod.google.com ([2002:a05:6a00:22c5:b0:730:96d1:c213])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:1382:b0:73b:ef0a:f9dc with SMTP id d2e1a72fcca58-7404775cc89mr5787948b3a.4.1746122864623;
 Thu, 01 May 2025 11:07:44 -0700 (PDT)
Date: Thu, 01 May 2025 11:07:42 -0700
In-Reply-To: <aBECik9V2uAlFKGU@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250402002936.960678-1-seanjc@google.com> <diqzplgvxbsm.fsf@ackerleytng-ctop.c.googlers.com>
 <aBECik9V2uAlFKGU@google.com>
Message-ID: <diqz1pt8xl01.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [ANNOUNCE] PUCK Agenda - 2025.04.02 - No Topic
From: Ackerley Tng <ackerleytng@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, roypat@amazon.co.uk, 
	kalyazin@amazon.com, Fuad Tabba <tabba@google.com>, 
	Vishal Annapurve <vannapurve@google.com>, david@redhat.com
Content-Type: text/plain; charset="UTF-8"

Sean Christopherson <seanjc@google.com> writes:

> On Tue, Apr 29, 2025, Ackerley Tng wrote:
>> 
>> Would like to add an agenda item for 2025-04-30's PUCK meeting: KVM
>> memory attributes vs guest_memfd shareability.
>
> Does next week work for you?  I.e. May 7th.  I won't be able to make tomorrow's
> PUCK (about to send a cancelation mail).
>
>> guest_memfd tracks shareability to determine whether a page can be
>> faulted by the host into userspace.
>> 
>> pKVM does not use kvm->mem_attr_array for tracking private/shared status
>> of a page, and for Coco VMs like TDX, there seems to be duplicate
>> tracking of private/shared status in guest_memfd's shareability and in
>> KVM's memory attributes.
>> 
>> I would like to discuss a proposal for shared/private conversions to be
>> performed through a guest_memfd (not KVM) ioctl instead of using
>> KVM_SET_MEMORY_ATTRIBUTES, where Coco VMs using guest_memfd for both
>> shared and private memory can be able to (with some other changes around
>> KVM memory attributes) skip tracking private/shared in KVM's memory
>> attributes.
>
> Has the proposal been posted on-list anywhere?  I haven't been following the
> guest_memfd threads very closely (understatement).

We managed to get it discussed at the guest_memfd upstream call. Here are
the slides, updated with discussion notes:
https://lpc.events/event/18/contributions/1764/attachments/1409/3708/2025-05-01-kvm-memory-attributes-vs-guest_memfd-shareability.pdf

Please remove the topic from the next PUCK! Thanks.

