Return-Path: <kvm+bounces-8226-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 94F7D84CD09
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 15:42:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 24EF7B25ECF
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 14:42:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D0617E778;
	Wed,  7 Feb 2024 14:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="f0ZEToLx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E39B676911
	for <kvm@vger.kernel.org>; Wed,  7 Feb 2024 14:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707316933; cv=none; b=jTBrspcvLjTNfTQiDTdvUOodG8MQEu3TLSiAEhqaplaU5gfGMSTjy46l5YnZsC6wYwYFqsYUjd6sGHjfSZM8nAdw+uE3K5UcytoC5QMVYhmCPWoJ7eeqSKfMDj1KhB47bpsOCulWEboSenNPWGziNpAuQF+7GBwvJHpQXspOeSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707316933; c=relaxed/simple;
	bh=3Cv8/QhBIpD74slYSSoo4vxVIJLl/J4xx5zC5DQgKTk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZRxI6CHhPo1XkbhpBc+F/HYrQhb/JkdabPStCeSNJtAC9AUok1/4GzB6WrgqpOA7wZVIkh5YOOvx3jdDME8nwX5pXVZ5PpzirYQxAhTQ3GM6P4D+6Un9D/BpNOh1Cmt9N1eUbWyw8o5Q8ccy0ZnsPYcHHnsz7xNUDygH5kuO1Ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=f0ZEToLx; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-5ca4ee5b97aso503647a12.1
        for <kvm@vger.kernel.org>; Wed, 07 Feb 2024 06:42:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707316931; x=1707921731; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=P+knB1ngdSyKARG/doZP96ZXvsPHGkqMevFJ+aYaZPk=;
        b=f0ZEToLxMs5TDBDkMEF2LePt9f4ymD9ISzVGM1Ft+/s6mrYclpP04f6PklXj3OTx3H
         wcR+ulr1eIOKWmu3p7Tz5NKfbQqfO1OkP0FjXxVvHLXdkyL3zSquUkDAevegBQYzZwmM
         Iov5KqUInUM7fdr8mHwf2BIAqTCYKAISl+gMTwtyPePd8urAmsgvR532GN4YwS6Ao92a
         MAtUqdoj3LfnnaOQq+1vojACoTQJnhZJcGY9HndsFEBK0l8zd+JxX6qZS6t4DJPjFB7k
         neDSnwGGUyb7YRutDLt+2HBJfkqcZZaHX/kmfREMAnTDfIcGD94l+50XXaADW5vKeMmp
         lF5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707316931; x=1707921731;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P+knB1ngdSyKARG/doZP96ZXvsPHGkqMevFJ+aYaZPk=;
        b=jgYiG6sx6VySkDikQaUbmm2YqphC+5Alkea4CRSWDhLtULWXAnMs7s6L68AACNJ64Q
         Ygqx7K00n2X5eq9CVSTYXXLkY0nzcASqdMHfgeuxq/3rRH5vGo26XizvGYaNKY8HQWB2
         777fVBNO2SLtsrhmewnw7JmGTDVwwFVXoN/kDfCt1aPC+acQKOy9VJgP/HlUKQTrFSWC
         E2H+ReLcmWIXZbnE7lYIZaXKRwf+QM/euppC4QPmExkj4dOW8YMnX99XuH7qe/8EjC60
         ydXzz61+T1G7C89Xd2b10MIeOA38Mor3c4jdF/wYNFQJ1hfwD28qPPuLKoYbxnlOBtpG
         GIbg==
X-Gm-Message-State: AOJu0Yxfe9j/Wj/gcnJOiOcVxmc9Z7ofOzSD7/P6sXgOGeHlXF/HfS87
	Zzz1aszYUjsEQygcvR5V7Yai+OR3pmRbZrRMdVqDVNlGHE1BwJsZne4orL2S7z7ccI2DJYT4g4P
	5Uw==
X-Google-Smtp-Source: AGHT+IH2CYj13LOcOTolr6P9fTU40Ga1BYphTzszQJKE8pMlAoy03SGK9b1MwI11mOBq96zOCeNblDSCKiQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a02:190:b0:5ca:439c:86ac with SMTP id
 bj16-20020a056a02019000b005ca439c86acmr8804pgb.8.1707316931114; Wed, 07 Feb
 2024 06:42:11 -0800 (PST)
Date: Wed, 7 Feb 2024 06:42:09 -0800
In-Reply-To: <20240131233056.10845-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240131233056.10845-1-pbonzini@redhat.com>
Message-ID: <ZcOWwYRUxZmpH304@google.com>
Subject: Re: [PATCH 0/8] KVM: cleanup linux/kvm.h
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Jan 31, 2024, Paolo Bonzini wrote:
> More cleanups of KVM's main header:
> 
> * remove thoroughly obsolete APIs
> 
> * move architecture-dependent stuff to uapi/asm/kvm.h
> 
> * small cleanups to __KVM_HAVE_* symbols

Do you have any thoughts on how/when you're going to apply this?  The kvm.h code
movement is likely going to generate conflicts for any new uAPI, e.g. I know Paul's
Xen series at least conflicts.

A topic branch is probably overkill.  Maybe getting this into kvm/next sooner
than later so that kvm/next can be used as a base will suffice?

