Return-Path: <kvm+bounces-18539-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E2708D65E1
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 17:37:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DE3A228EAEA
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 15:37:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC66F74042;
	Fri, 31 May 2024 15:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gxZragxL"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 549B2446D1
	for <kvm@vger.kernel.org>; Fri, 31 May 2024 15:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717169861; cv=none; b=UnwuO6gv3iLTMSZJ7oVgKhDT7ji3ihZGP8SPw6egOONawFIkDUyhQhF06crWS0aLY2rbuZKWsUe0mZusTgah9D2/ln88lFPHtBqooMGJI26igrTzGEc20n2LIxqpT+lmbrkK/aIaAp25/V7NYVFegpOqq9wjFATvEYrg5frdmxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717169861; c=relaxed/simple;
	bh=u7WXE0bDQh0az+G8u0STqXZqasu62w7RwKd+cCLRXMk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QgPUq2Ae/RNVgRmtAupX0qyMbXKY/6VD6THaRZuMLs0tCbLnD6mdv5R1XRbPU9maEgbn+umJ9rts66H/0w9RnG1QddiwgJ0OI0K1qNUxe/Y513IIyQTS5QN+ix23282I2bSJJQCLq1ArfCXV0wjTi1kGFL1vwrGrHdEtecLKMNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gxZragxL; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717169858;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6lRY8EaNTOP3RKgAAY+bW552VmvXSSymUs3S+NhhY50=;
	b=gxZragxLyFtYmjEshdsbg2lqNjQAouOfplWKgOdUZ5rVmFjQfgyVDyIMrODO9BfBGSpxTe
	sdyd7bYHZn5YThCESAmKDOXJh4PDv77OfJAQQ16T0KjwkKVMpyI5TcVnt9Rk0J2ttCJ7HM
	Mk74+QWhp3tcHSLivZcktZ5QOUrELwA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-454-SzS9Ti1oPkuAEPC4MoN8ng-1; Fri, 31 May 2024 11:37:36 -0400
X-MC-Unique: SzS9Ti1oPkuAEPC4MoN8ng-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-35dd0cc1a7bso609964f8f.1
        for <kvm@vger.kernel.org>; Fri, 31 May 2024 08:37:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717169855; x=1717774655;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6lRY8EaNTOP3RKgAAY+bW552VmvXSSymUs3S+NhhY50=;
        b=SufhbM57k+1deWD1LCfOPIltXdv+vfCEW8xVKfw8mXUArUwEr9/z7Vb+PbwSbtmZ25
         OdM4A2l3UeKe7oBXlpiW0mpn+dgHDdTBFc86P3QxTvcJI1T+DhdzX4i5569waCaiqbMp
         MxHSjITIUOpO/zcSBcSlqgqJO0WdUh7MG7C7TkqkJEf9vPsD910TXNmVL0CcnSnJPVw2
         cqFdYkHzAwkrAQ2URyY4Heh2c1CVtuFHcZg/z4zOp6NGgc6oJV2DjZ0l4hkOv0JOtl2r
         j9bdXCVIxn6CYJLecwp1NvApmnVYKGVfq3vu86yCV4QrFFpam0iZ03Gb63bBHBzHpooj
         LYrQ==
X-Forwarded-Encrypted: i=1; AJvYcCVEYha/kaUjXkRdaTIAGlTbGF99dvEni8ZH6enTesl7WzZFDSqGSF57VRi7HEOwmCDK2mAXGHd/a1xbUUL+OnYzTEVo
X-Gm-Message-State: AOJu0YyhDpr++Zc+OPgtd+1QK6Q0iOQB8DsB0IlZ6QjPwLQm8sEmiboh
	wGiLVhk6n7599WkCsPBl5lN/oxg3ATntVHQfJWOooWMC695Div7FRaMj7kA7gAq8rkUsHrf1L7d
	y4j+mCPdMLfyhx5B1ev20qlg8LMF/YtCsqGGywDspCDhCH/knVZCS94CfAGNX5AEMBAREKZNHMN
	OTpFWVwQNGNnUdSYoiyn0qPuve
X-Received: by 2002:a5d:5392:0:b0:34c:6629:9962 with SMTP id ffacd0b85a97d-35e0f284638mr1714900f8f.30.1717169855259;
        Fri, 31 May 2024 08:37:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFduiW52sGnR6g6gdSst7zYUAfFkyt3TRq9RsSXiitRrzNyhRAnnzGTi0mhW37ETjIqjH5sjaGYHYT6IhsX+a4=
X-Received: by 2002:a5d:5392:0:b0:34c:6629:9962 with SMTP id
 ffacd0b85a97d-35e0f284638mr1714881f8f.30.1717169854851; Fri, 31 May 2024
 08:37:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240530111643.1091816-1-pankaj.gupta@amd.com>
 <20240530111643.1091816-3-pankaj.gupta@amd.com> <774b70fc-992b-47bc-84ef-c5a22b96c63a@oracle.com>
In-Reply-To: <774b70fc-992b-47bc-84ef-c5a22b96c63a@oracle.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 31 May 2024 17:37:22 +0200
Message-ID: <CABgObfbtWSbL9zY1yMCmqsycRnF74=bOQBqrKitOnQpL2ZKN8w@mail.gmail.com>
Subject: Re: [PATCH v4 02/31] linux-headers: Update to current kvm/next
To: Liam Merwick <liam.merwick@oracle.com>
Cc: Pankaj Gupta <pankaj.gupta@amd.com>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, 
	"brijesh.singh@amd.com" <brijesh.singh@amd.com>, "dovmurik@linux.ibm.com" <dovmurik@linux.ibm.com>, 
	"armbru@redhat.com" <armbru@redhat.com>, "michael.roth@amd.com" <michael.roth@amd.com>, 
	"xiaoyao.li@intel.com" <xiaoyao.li@intel.com>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, 
	"isaku.yamahata@intel.com" <isaku.yamahata@intel.com>, "berrange@redhat.com" <berrange@redhat.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "anisinha@redhat.com" <anisinha@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 31, 2024 at 4:38=E2=80=AFPM Liam Merwick <liam.merwick@oracle.c=
om>
wrote:
> > --- a/linux-headers/asm-x86/kvm.h
> > +++ b/linux-headers/asm-x86/kvm.h
> > @@ -870,5 +919,6 @@ struct kvm_hyperv_eventfd {
> >   #define KVM_X86_SW_PROTECTED_VM     1
> >   #define KVM_X86_SEV_VM              2
> >   #define KVM_X86_SEV_ES_VM   3
> > +#define KVM_X86_SNP_VM               4
>
> I'm not sure which is the best patch, but there needs to be an array entr=
y
> added for vm_type_name[KVM_X86_SNP_VM] in target/i386/kvm/kvm.c

Probably "i386/sev: Add a class method to determine KVM VM type for
SNP guests", which is where KVM_X86_SNP_VM appears in the code.


Paolo


