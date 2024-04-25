Return-Path: <kvm+bounces-15941-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EE95C8B2623
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 18:17:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 416D1B22F71
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 16:17:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1266B14D2A2;
	Thu, 25 Apr 2024 16:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MFFd6I6e"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D322C14C59B
	for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 16:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714061838; cv=none; b=SMM+S/+fNZuBqo1MRsdaYn028JC82dhY9JZ/oSRReVcJI7zG4KW7s+1nFjNqTBheGLSblqpH1Gv73emFBuhQ+jq5tSHNWqVMKghaeADUQ+20VBVKEu60RbPvdO2CPqP7e0eW9Zh6fo760JyLsxjY59kFEXTaJenaaax2oBp9Hb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714061838; c=relaxed/simple;
	bh=GV4FXuGcsXUscg6v8KLdZXyTdNFxTvzqhdjBQx4V3/w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PsLDU3g+eVdwXEmL220WXGc/n2CIVreceQiLbH39rGBtHilDDaRxnh6dSP+d6LUdXpnCkP5GOs9Nm5cBkCIA117sa7035zJSfvjG3ar1xU/bcE3wnnLvAP9cvwpuIgS/RZyR9/XNJyim/WNI2Hd7HumWxxx42/nGgKyyNXNtXhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MFFd6I6e; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-6f391017e0fso856914b3a.1
        for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 09:17:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714061836; x=1714666636; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ugMpRYVYPzcA74XJBgKj/Xa2Cvtj2B5SD6ewAh4zjY0=;
        b=MFFd6I6e/jrf5hmB/xEurh/+7QNhVPxi4fueUhDAqACJbqdnIm5ghrdYInYceN1bMv
         nl0uJ63Q65X8MgAxM5mvm3REZlVv6xnTdjl/ef3A8JzNoEPILW0ZJ3AgW8hFP+TX+H9L
         jQ90E4vynYJM6/Brw6Bkk6RUb46WGM1Xf33z1O6rW8XKAdt9Qh+AGMgHU0eMK/pUvA3K
         d0CI8odu4v7iRu+03MmqjUrk1Q8qxDrakW+9PK8+ehlU0GqlAbYOxHvsk8IO1Uz0h6qN
         efe+7XSnIeoZJy+0L0ePM7YKJheqFbjya9lf5R8yk/Bo9NiE01A7hf5IYe8QpyYqtAXf
         sENw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714061836; x=1714666636;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ugMpRYVYPzcA74XJBgKj/Xa2Cvtj2B5SD6ewAh4zjY0=;
        b=b9UR1B/kDP2KLDemagTwwO6e5KcIMfDkOu6jFVYtZ9NOjCfgMbB7OcT7RrJXK8lNwJ
         Hm9zOPc+/Tmla9BeAxBrPOZZ97RtXz/cCxMANn1mEs4SChUdDWHu+2VQPmrpM2cgmq4l
         ITgoAGl91qkkSRgcPCke6zJ3pB2qCgA1u9lPWRh7U2T5OHaIIM7df11z4YqnOpNo9kpH
         NY2AyxRh/tSPCU1O5PDVI+4hVtoCvW/+H5F28lJ1DBPE4Sov+cmYbpnM5BUCAZmEHaNK
         jJ++044rI352PYGny8uXZByLpbdBuiIpalb6hEanKXy/v8BiTBWrnRcVs1dqWs+CaTQu
         5MDA==
X-Forwarded-Encrypted: i=1; AJvYcCU+Vb5HHQffRqgIm0aZqUrM1YsUqVjd8Yf1SPmjMYVc/XJa/jSh/7T5m33CwgTLBNvg3GS/I4mknFFzvfjspYiJrnOh
X-Gm-Message-State: AOJu0Yw2mXCE03LOGlXdGb6ED73GmGeQWBLye6ImBNyMtNLcjHfA7F10
	eufiw/V4sGDUw3l7+LXuSAbTBIVwLhLLW+oYabnfUWIWzuyeThH3CGATBayoUPayMYeG3Q8EAvj
	UWw==
X-Google-Smtp-Source: AGHT+IEb1nuGz+6fxj/3DxHpg62zrmaNOXu6Kzmf2j0vCLYWLB27deyGnTJfaXe3ZmIVCWz59/NEjvLJwiw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:93a5:b0:6ec:f18a:2771 with SMTP id
 ka37-20020a056a0093a500b006ecf18a2771mr4877pfb.5.1714061835911; Thu, 25 Apr
 2024 09:17:15 -0700 (PDT)
Date: Thu, 25 Apr 2024 09:17:14 -0700
In-Reply-To: <ad48dd75-3d14-461c-91e4-bad41c325ae7@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1711035400.git.reinette.chatre@intel.com>
 <6fae9b07de98d7f56b903031be4490490042ff90.camel@intel.com>
 <Ziku9m_1hQhJgm_m@google.com> <26073e608fc450c6c0dcfe1f5cb1590f14c71e96.camel@intel.com>
 <ZilAEhUS-mmgjBK8@google.com> <ad48dd75-3d14-461c-91e4-bad41c325ae7@intel.com>
Message-ID: <ZiqCCo9WipMgWy8K@google.com>
Subject: Re: [PATCH V4 0/4] KVM: x86: Make bus clock frequency for vAPIC timer configurable
From: Sean Christopherson <seanjc@google.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: Rick P Edgecombe <rick.p.edgecombe@intel.com>, "jmattson@google.com" <jmattson@google.com>, 
	Chao Gao <chao.gao@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "vkuznets@redhat.com" <vkuznets@redhat.com>, 
	Vishal Annapurve <vannapurve@google.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Erdem Aktas <erdemaktas@google.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Wed, Apr 24, 2024, Reinette Chatre wrote:
> There was one vote for the capability name to rather be KVM_CAP_X86_APIC_BUS_CYCLES_NS [1] 
> 
> I'd be happy to resubmit with the name changed but after reading your
> statement above it is not clear to me what name is preferred:
> KVM_CAP_X86_APIC_BUS_FREQUENCY as used in this series that seem to meet your
> approval or KVM_CAP_X86_APIC_BUS_CYCLES_NS.
> 
> Please let me know what you prefer.

Both work for me, I don't have a strong preference.

