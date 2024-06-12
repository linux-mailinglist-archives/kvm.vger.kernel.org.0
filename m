Return-Path: <kvm+bounces-19433-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0753D90508B
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 12:39:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A24A21F23C54
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 10:39:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C59316EBFA;
	Wed, 12 Jun 2024 10:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="MvCBZd1i"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D81236B17
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 10:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718188751; cv=none; b=ewNB4bOSGX1p/y2tKMGN/VlTokyE1rqXLrLMAN+8STS3+Lxpq2uhoGhmO3uS4sdrWHsPq/K/xou/mpPI1tYblyQmP8djZFNqJxpITLbROq40+F7WRrJzCm6UjPHyjDTfsR4QJoiEijhRYEiPy8cO6/h2Dwn/XnT6ULkI9ix1ANc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718188751; c=relaxed/simple;
	bh=S7LtIdD6IXZq293yndaSK73zT2xsNSO2FJIRnwsGoSk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dgfOFraBDbYif9JCfkY9lgE5xN6GY6xcEQ6NU5ywR6gDwUt/VsZx7FnVDmdOvOYJj4i3lN6C9EybOd2b3D22zbILeS63FY5vQcOpYDC5+t+WvGW/EBH1j/idyOTLJc1JsISBe5yh4hyf7Mjw4FYcWSd7VJiLxu090dVADRfkmTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=MvCBZd1i; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4217990f997so35610595e9.2
        for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 03:39:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718188748; x=1718793548; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YfD1VqZzELeuz1QNMdGkPvLMyqAG2nm5+OL8OY4ucSM=;
        b=MvCBZd1iUZj+GBzwm3H7aLVSjFfRgGdpxKzrhL9lVV85VZT8XXQVGd/X84Pioo9r/G
         WR01sXSGqxQrcXvRhxSfODSqwbcXf5UmsFEIfkI/8KCNNZY5atlg0zUlClNSrT9G9lf0
         qA6r2UxpuaFeux3JbB4xlsYlP37K7YDlYXZhexRY/JFMZM6ioSd1klBe5KqwFEMsjEIS
         CUehnKOXiWRN7J3hPfpMdvnCBSlYSp5ZQirBKZB340C0nkrEOdqWKqSfQzzk1x8aUKPD
         q7TfGiOy1NKb21q5954i4x40e5GnofYHbtipdy9XhfXLha21DAEt/GQr/qoAcNopsJra
         lO6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718188748; x=1718793548;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YfD1VqZzELeuz1QNMdGkPvLMyqAG2nm5+OL8OY4ucSM=;
        b=X45CEJs8B3FMnyBPZvEA62Ymrq1pV53F+rAsEMuogvfsAn6+dY8ZUfW7nXKi8XXeYP
         U3J4ecXKPmRkG4hMl66UiVqJwBVHqQ92V9PQiSzNRuWQFjcMwgPpGSDeGfwvb02XT6G9
         qdXskjate1/8DXt79VZhwtk1l2/PJYib9J5uFoUoX9IjvaAzlFbY3Z1OtneeKN4hhf2v
         NXbVlX8jk3e+DjP56Ef+uZ1v5gThoi4aHMW/WjW2mmZiC07x8QAfawHUz4YUs9xg4ObA
         Ybfpw5+GrG2DH1fJXcqyDOER+fgfADuOkd8xFsVilW7FwTYErIxec3+eRjT0svovBRpg
         cCCg==
X-Forwarded-Encrypted: i=1; AJvYcCWBntnZzGuVkJ7yxNaDpvkfiaqbqHXCWDmRbov0adcaptIuM6jLMkadtDsTpwq9ivJ8CqsczDyjX0vWZzVWmsnw3Fyg
X-Gm-Message-State: AOJu0YzU9DuX9/WzQ7mkRk9j/GSKQf8iDlyAVKMkAH4qlONIaeCjEl+y
	VM4y+XbaxYwULucsyLZQutkrUE19Qg588rQ/iGVfr9QtPvJIWdwXZ7YBEfB7TWI=
X-Google-Smtp-Source: AGHT+IG2sRx7mMogUgoJ8iAYjE31Oo5aulgtpW+ZCzhac5XAxW0N3ug26Of695k4kA7aaQpaEzc6kQ==
X-Received: by 2002:a05:600c:418b:b0:421:cc89:dd5d with SMTP id 5b1f17b1804b1-422863b4c15mr9051705e9.9.1718188747645;
        Wed, 12 Jun 2024 03:39:07 -0700 (PDT)
Received: from localhost ([102.222.70.76])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42286fe9184sm20619335e9.13.2024.06.12.03.39.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jun 2024 03:39:06 -0700 (PDT)
Date: Wed, 12 Jun 2024 13:39:02 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>, kvm@vger.kernel.org
Subject: Re: [bug report] KVM: SEV: Add KVM_SEV_SNP_LAUNCH_START command
Message-ID: <f3cc08d7-bf74-4094-ac70-1fb1b4cb8992@moroto.mountain>
References: <d9c16deb-6fad-4ecd-a783-4c4e9f518725@moroto.mountain>
 <76e66fa2-4a36-4de1-96a3-b8893130ed74@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <76e66fa2-4a36-4de1-96a3-b8893130ed74@redhat.com>

On Wed, Jun 12, 2024 at 12:17:19PM +0200, Paolo Bonzini wrote:
> Thanks for the report!
> 
> >     2134         /* Don't allow userspace to allocate memory for more than 1 SNP context. */
> >     2135         if (sev->snp_context)
> >     2136                 return -EINVAL;
> >     2137     2138         sev->snp_context = snp_context_create(kvm,
> > argp);
> >                                     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > What this static checker warning is about is that "argp->sev_fd" points
> > to a file and we create some context here and send a
> > SEV_CMD_SNP_GCTX_CREATE command using that file.
> 
> ...
> 
> >     2156         start.gctx_paddr = __psp_pa(sev->snp_context);
> >     2157         start.policy = params.policy;
> >     2158         memcpy(start.gosvw, params.gosvw, sizeof(params.gosvw));
> > --> 2159         rc = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_LAUNCH_START, &start, &argp->error);
> >                                       ^^^^^^^^^^^^  ^^^^^^^^^^^^^^^^^^^^^^^^
> > The user controls which file the ->sev_fd points to so now we're doing
> > SEV_CMD_SNP_LAUNCH_START command but the file could be different from
> > what we expected.  Does this matter?  I don't know KVM well enough to
> > say.  It doesn't seem very safe, but it might be fine.
> 
> It is safe, all file descriptors for /dev/sev are basically equivalent,
> as they have no file-specific data.
> 
> __sev_issue_cmd ends up here:
> 
> int sev_issue_cmd_external_user(struct file *filep, unsigned int cmd,
>                                 void *data, int *error)
> {
>         if (!filep || filep->f_op != &sev_fops)
>                 return -EBADF;
> 
>         return sev_do_cmd(cmd, data, error);
> }
> EXPORT_SYMBOL_GPL(sev_issue_cmd_external_user);
> 
> and you can see that the filep argument is only used to check that
> the file has the right file_operations.

Ah.  That works.  Thanks!

regards,
dan carpenter


