Return-Path: <kvm+bounces-14988-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B23738A87F6
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 17:42:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 66C921F243CF
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 15:42:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0339147C6B;
	Wed, 17 Apr 2024 15:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WZ0JJtC2"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F8E3140389
	for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 15:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713368533; cv=none; b=hrpnxpkVUkw8u6d+wfHl6WW8pHNtxlfga4a2ZhzeXSstTMaxVJt/1R4HHlIWF9uGsK7bxC+Bmg8hbwvBt3teEZk/cKmWIy67FbFC21HMMShTyRTTjz1ECbqZleFg5bd5nkbFD3qaZRa5dDopZrA3Tbkdt/eP7HVMbTw0dDOlYzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713368533; c=relaxed/simple;
	bh=7gVkTYWNNgR6Ee0qa0UmIW+l7/HdkMilyXO4kdChYvw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jORn3VydLgF6jA/rVI/yIZAK8MjqW23IhMYp/n3H259l8JBf/5fmA4vb4zcyEfW7CreXWBva8cDGxWyjKA4FEAxjDt4fnOjUvptkViQ+dO7y1u2GxHEBDn45NfJGa7jWuMOnW4y4uYTf2+V+mwtM6XiZdsbF2pOr0mtxEfj6nHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WZ0JJtC2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713368530;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dzERyazOZhZDFp//yk13CO/EeXSCUMQ4vzlhZ6tsJ4s=;
	b=WZ0JJtC2UgMV8K0Jqiqb0DOi3ikMRg0E9mxrN5LKh4CnfBdSOUkisFgUc2bg3XIqwgy0Mu
	pEnBBOf6zN3oQ9qVlhG+qIl9zLiiiOoU4HwUXClogw1eaA1IqVZw1dEiTNw/WAME92wjl/
	Nv8O/8dVI/Vwk4zAMP0iT6xqDcA2P78=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-687-_rLt_zDhNEGs2j82YuAFwQ-1; Wed, 17 Apr 2024 11:42:09 -0400
X-MC-Unique: _rLt_zDhNEGs2j82YuAFwQ-1
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-6ed5a1724b2so2833425b3a.1
        for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 08:42:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713368528; x=1713973328;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dzERyazOZhZDFp//yk13CO/EeXSCUMQ4vzlhZ6tsJ4s=;
        b=dlpAFJRIO+zzPzMw0IGrRxu5chPHBS5ykvbSKijvRsEsZ/tfvii26NuuSFzDM1yEWm
         YA51mjkqXytWD06xSVdIvTgaye0UjBtlrVtmAnOun8KjI+vTo0y2SaI9ARwuML9itTuy
         Etn3YEcXzROF/C3yAgrfT/YN0ognCjCNUtQ1nRHt8qCo9AJsY9lVr0RYLS96Eb1lVibx
         cnb6ayZ4ug1LTABn0YhLKhboupsFMeXsp0KHqYSAeoLg2bjE242xJA9INMiboerC65Vy
         mqTcea20oYOBv243FTA2vDcMVgLbq3h/3oG1VKBteXYLEmpGnDbnZgFe6Pm8bxojPUoo
         W3kQ==
X-Forwarded-Encrypted: i=1; AJvYcCXeIiMJib397jmtgCzeNpi3Asxfx7d7/Fkcitnw3bF8LajVoRSpFrFsHhuDo9bt2zerpxHBm3kpI8cQZ9Avum22erjy
X-Gm-Message-State: AOJu0YzU1t/4fQ1+gyN7Dyj9fENMNP8BIm9uv3dvrp6ECS7mRP4krja9
	FZ8N1HhhQdHwurD/WoLP/qamhTFYmp5h5y/1HY8/vDANW4hZMwIQOdttyQfRT/MqQ+0l8hD2/Uf
	ZjK/t5EmvzN0R3mTH7XcXqIedGgSM7t4uEPMxp0jxF6ve5oEzFeyDo20jizwQEsRa+hehDdcB5e
	o6NSOdO+SF6SxY4aYYdp726682
X-Received: by 2002:a05:6a21:8802:b0:1a7:4a6f:ec4b with SMTP id ta2-20020a056a21880200b001a74a6fec4bmr17428753pzc.35.1713368528176;
        Wed, 17 Apr 2024 08:42:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGA7qaavrOyPAmWc+BQO+KFe4vxronaHCXQ8eu3uFOXgOr20CvQtR70dFyBzIAxlmu+kRXqTad/LyK2LFTXMi8=
X-Received: by 2002:a05:6a21:8802:b0:1a7:4a6f:ec4b with SMTP id
 ta2-20020a056a21880200b001a74a6fec4bmr17428721pzc.35.1713368527850; Wed, 17
 Apr 2024 08:42:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1712785629.git.isaku.yamahata@intel.com>
 <ddf1d98420f562707b11e12c416cce8fdb986bb1.1712785629.git.isaku.yamahata@intel.com>
 <621c260399a05338ba6d034e275e19714ad3665c.camel@intel.com> <20240416235230.GB3039520@ls.amr.corp.intel.com>
In-Reply-To: <20240416235230.GB3039520@ls.amr.corp.intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 17 Apr 2024 17:41:55 +0200
Message-ID: <CABgObfb0AFfnLnEz3wervoHLE8em_nDbGEFzSH8F5WZObyWk0g@mail.gmail.com>
Subject: Re: [PATCH v2 03/10] KVM: x86/mmu: Extract __kvm_mmu_do_page_fault()
To: Isaku Yamahata <isaku.yamahata@intel.com>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"seanjc@google.com" <seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>, 
	"federico.parola@polito.it" <federico.parola@polito.it>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "dmatlack@google.com" <dmatlack@google.com>, 
	"michael.roth@amd.com" <michael.roth@amd.com>, isaku.yamahata@linux.intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 17, 2024 at 1:52=E2=80=AFAM Isaku Yamahata <isaku.yamahata@inte=
l.com> wrote:
> As Chao pointed out, this patch is unnecessary.  I'll use
> kvm_mmu_do_page_fault() directly with updating vcpu->stat.

Actually I prefer to have this patch.

pf_* stats do not make sense for pre-population, and updating them
confuses things because pre-population (outside TDX) has the purpose
of avoiding page faults.

Paolo


