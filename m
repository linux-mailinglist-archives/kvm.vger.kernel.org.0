Return-Path: <kvm+bounces-16547-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 938868BB5D6
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 23:35:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CAA38B24237
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 21:35:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFD4156443;
	Fri,  3 May 2024 21:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Et1FCOL4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEA5533CF1
	for <kvm@vger.kernel.org>; Fri,  3 May 2024 21:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714772070; cv=none; b=jRCHKk9CXL2+s/YebfPx2IV8stbF/9xhgkHoT6t9Iiy3Os5C4OXk0R2YLRddMmhQlJA40uWbeADxmNC1F7wFT7bWhWQhucdgQ0B5I8hBKVX0Urh2cCOIbeaP84o0FqLk7DWKT4s/DSBHIsbuWCQI3qLxlVt43k/MagZSTywOZXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714772070; c=relaxed/simple;
	bh=oq0unBzSDZxfLcXtYKNrFLrUch8MutkRmuUhAom/O00=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=F06gK0rL3uOC324tb292ai9YKhsCtK74qyQ0YDOz7DLFGWnoIrtYyjj03516nREi6AS3JbuwAxQVBenI/aXyrymv8tMFfFdWIOA/Z2RBVILNHJmjpx4sNF1D3+tE5lwRzHhH+NsGRu6mKtP0EY+mXQ/Wg8lKb+iw+B1ZxDhjP6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Et1FCOL4; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-61be452c62bso1306317b3.2
        for <kvm@vger.kernel.org>; Fri, 03 May 2024 14:34:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714772068; x=1715376868; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XfDtOIpv/VQBANmhQA7+/FUy8DMKChgN64LUKk5KMsI=;
        b=Et1FCOL43rZ1qxj4F4U6+NFEVT8IyIQgUTGCVAG+/omDfGUzjXYL5GYPiz0CNP4YHu
         hVXqw290eFeen0rN+ROGHFkrNk1DpOolsvxJ7k1kZa+xlTE2DsUc/7bCV7ziDF38KDyQ
         RrvLw0Yf9K+cK5uu7yJtuDKiQtXIriP09iaxDQBK2brpsF34iNqIf688w/RTGpIUkNdq
         XeavoRmQYBhm830MjY/9hXHUSk0k/thA0OWDvd3b4ABnOpClTrFLEpbszWX1Ih3eUFsF
         ldaXPNDyuo8t9AgWQ4ga0vwfLUuR2c9Ci+fWNv0Ugkq05Y6/a0Yyk0zXbM8JqB5DvzOR
         e3kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714772068; x=1715376868;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XfDtOIpv/VQBANmhQA7+/FUy8DMKChgN64LUKk5KMsI=;
        b=rfsTBcFCObgDSxeTtsbSVYbdww+zvj1XKIjnO6bP/Cu4tMQKUoowzLF11+RViJ/HFw
         9TmyHpe7VriwJCKR0hEExve6SpknO8qY9LChYdApMYmq81ltJWAFczs8Vd2GuIfUJbS8
         ElHDasJ7yM8XhZQ/LX0DwAqiNlJQpMH8Bcevt+6PDfIaPJlyoSY9xpChDNMRzTyclCAH
         Rmmc8o8+59+P86P/GScGQTiVv0zGYPGQqYVrsvhqRI5Pgw+MTy+x90AhhSYIVZ/kYoBT
         mOI7iww4ibWWX6eAdMUaP5zUSZdVs83VGqp0FL/+TIs6BTUDzqP/XJ9rdsuBravpnY+b
         6cZQ==
X-Gm-Message-State: AOJu0YzRoSecxGTfcC/DTkpiffcCMtYsQWcJpgh2yojDGvv1WTaFQIdL
	rQGtjV0n8LNnR0D63UUqSDQlieqHEYApPFGijoQzZPWiQRiVWx1aFpcKZ2fg4QlS+oUDU+EXlDh
	TsQ==
X-Google-Smtp-Source: AGHT+IF/se/5We+ADnMl1CUfttYfOuat1yw+wr3JyaJMsRPfx1XmFzz6oFuflwlXtV+V3r+BecrwvQkFOUQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:a147:0:b0:61b:e103:804d with SMTP id
 y68-20020a81a147000000b0061be103804dmr779582ywg.0.1714772067906; Fri, 03 May
 2024 14:34:27 -0700 (PDT)
Date: Fri,  3 May 2024 14:32:24 -0700
In-Reply-To: <20240423193114.2887673-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240423193114.2887673-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
Message-ID: <171469177238.1010157.17892485185197174264.b4-ty@google.com>
Subject: Re: [PATCH v3] KVM: x86/mmu: Fix a largely theoretical race in kvm_mmu_track_write()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Tue, 23 Apr 2024 12:31:14 -0700, Sean Christopherson wrote:
> Add full memory barriers in kvm_mmu_track_write() and account_shadowed()
> to plug a (very, very theoretical) race where kvm_mmu_track_write() could
> miss a 0->1 transition of indirect_shadow_pages and fail to zap relevant,
> *stale* SPTEs.
> 
> Without the barriers, because modern x86 CPUs allow (per the SDM):
> 
> [...]

Applied to kvm-x86 mmu.

[1/1] KVM: x86/mmu: Fix a largely theoretical race in kvm_mmu_track_write()
      https://github.com/kvm-x86/linux/commit/226d9b8f1688

--
https://github.com/kvm-x86/linux/tree/next

