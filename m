Return-Path: <kvm+bounces-8628-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D9CEA853694
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 17:49:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C47DFB2853F
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 16:49:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A788604AD;
	Tue, 13 Feb 2024 16:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FODxZYvu"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CAB65FF08
	for <kvm@vger.kernel.org>; Tue, 13 Feb 2024 16:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707842881; cv=none; b=JJK7KloVqrLLyGtm+nIHUo6nLFIOCDXOVQldw5p4Z98HZ5SKoI2BXWcKH/AV8sXGPh9Dl+jwHBz6ZxiB95DVlp+SDSRiZfPncr+O9OYqHyOtj6nYVSsDZN6yth9pPIB2xPvwtrBJaZqrHYyShMx5XMpYnlu5jSQ2LdiAgbfR7ZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707842881; c=relaxed/simple;
	bh=QMyITr22VNOez+0Eu6FIvd5XT+rl1JLLwyX/uWCBhQQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Mi0KKrTpVwbuufuXblwqgEAszbIoG07FRE86W85NL1BP+q+gWDou72hHM/NS1VO8XPnx3XRlL+MHS4zuZh12cz9zgZw8sedogn4xVUFJzf6Mi4Y2fTuCbCc4jcxT0/jNF8N5HbGBArA5GRqVB6m0krnA92H7yCv4RhSZ2RJahTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FODxZYvu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707842878;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QMyITr22VNOez+0Eu6FIvd5XT+rl1JLLwyX/uWCBhQQ=;
	b=FODxZYvuvfvnvqutrYSQgZh8eWSK7zFJ8kCgOIJnJsfUm31LRdrxsUYvC7hinV9aGueNUN
	yOKTtY+1CiusyxktCUhfrxFAISQM+aYW7kHkQVDhx2MNhKYHQMUURm6GGyWiNNYgffQv4i
	meUOSLkgY0Otae1URJmy+4GpIzWzt/k=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-453-ycZ7aOoBMNWj1RhXqk9eKQ-1; Tue, 13 Feb 2024 11:47:56 -0500
X-MC-Unique: ycZ7aOoBMNWj1RhXqk9eKQ-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-33ce3425ec9so64812f8f.2
        for <kvm@vger.kernel.org>; Tue, 13 Feb 2024 08:47:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707842875; x=1708447675;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QMyITr22VNOez+0Eu6FIvd5XT+rl1JLLwyX/uWCBhQQ=;
        b=JlnrqxJ3/0MDThIU1JJbiW2knT4Z0xgnzDc/+FQn02kTiDMJICgg4dr8xKCV8Y43qq
         yrpLyD60cjVQ7ssEDQeFYXy3MRI/IeJcNp0YXzd7xVdNGZcvNiyKCjE+uNNjeJzfCDWK
         bMDfH+KQoVRZmAT5vKbWPes1ythxIMgDUPMLjkCqs8cJsV+6NOdJsGpBnHb+s88TZQOy
         mbBGNM5/nRyDUsYfAWfEyKWzmohSlX5Yz/2+R0lTuRK4chJeR4SfL4DOn9hV8cGreGnr
         8yJbD4Ifbe6VkAqJoPHcFRSAoA99PC7CiKQUhdnNTksyRRdxVCFxmzFI82M8sZM3O5OX
         Oxog==
X-Forwarded-Encrypted: i=1; AJvYcCXjCPGSL2UTO7ltYTy6n7PfTdkoL0mvUwMtO9epiiX8+mF+bsDoCs8KQFZkA/I3ck8tjOJrXdpt+D3Jqpc1G0GFA4LX
X-Gm-Message-State: AOJu0YwBY9Ff94VZwCUoNbik6djeFcjFfcKeR0F3NTqoZh4+68lBNzGk
	LwELZ7PpgHfEjxzBhGR5BhdtDyhDtHbdK/JtqAUlB9WMPHUnFzvVUGe65y59Vx3NXFr8QTLEFrg
	o3G+jTMvLUNNK8hX6IWZDj3MY53r3rHqDpNVhurnTh2TbVAi2kPATesNaLqRSRE+ztmoyK6/l3p
	q0zG+iZMsjCi2WZY07kI+NAfyu
X-Received: by 2002:a5d:5706:0:b0:33c:e339:6b21 with SMTP id a6-20020a5d5706000000b0033ce3396b21mr317083wrv.3.1707842875439;
        Tue, 13 Feb 2024 08:47:55 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFjt8790Sjzdp3j57iU8n+hsTKRyoCw6s864kVDcam+5Q/1BmuuCqAAfIwXrcWPZpVf9etFaTvSje6Pkl6muNc=
X-Received: by 2002:a5d:5706:0:b0:33c:e339:6b21 with SMTP id
 a6-20020a5d5706000000b0033ce3396b21mr317064wrv.3.1707842875120; Tue, 13 Feb
 2024 08:47:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1705965634.git.isaku.yamahata@intel.com>
 <591420ca62f0a9ac2478c2715181201c23f8acf0.1705965635.git.isaku.yamahata@intel.com>
 <CABgObfaEz8zmdqy4QatCKKqjugMxW+AsnLDAg6PN+BX1QyV01A@mail.gmail.com> <Zcrarct88veirZx7@google.com>
In-Reply-To: <Zcrarct88veirZx7@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 13 Feb 2024 17:47:43 +0100
Message-ID: <CABgObfYFnpe_BO5bNRvXC6Y-3rUxFAogs2TGFUTBu+JR25N=pQ@mail.gmail.com>
Subject: Re: [PATCH v18 032/121] KVM: x86/mmu: introduce config for PRIVATE
 KVM MMU
To: Sean Christopherson <seanjc@google.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com, erdemaktas@google.com, 
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>, chen.bo@intel.com, 
	hang.yuan@intel.com, tina.zhang@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 13, 2024 at 3:57=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
> The only thing that even so much as approaches being a hot path is
> kvm_gfn_shared_mask(), and if that needs to be optimized, then we'd proba=
bly be
> better off with a static_key, a la kvm_has_noapic_vcpu (though I'm *extre=
mely*
> skeptical that that adds any measurable benefit).

I'm okay with killing it altogether.

Paolo


