Return-Path: <kvm+bounces-24419-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D1559550C3
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 20:24:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DC5E8B22E05
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 18:24:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36DCA1C3F00;
	Fri, 16 Aug 2024 18:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="e5/8dXii"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 183702F43
	for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 18:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723832679; cv=none; b=D7nBsELbJSor1FDxttZ7+w4rbv853yKketPemfdFlYPEiizS1uEWSqGoSPZg9JtsIhigiO3PEn+B5/989jk4wCDmsiKXO6w3JTCHdg8EiK7sZbJ6uvOo2WyCsvzMUPo50D/VB7PzGlqHT9RYfdxNY3kSTFPkHfaeQgALxaYXrxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723832679; c=relaxed/simple;
	bh=KfdgmwNQlJhITu85hViAhQH2m912GxeX0PW2gdRLWZw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dHPxVsst+fNeeCylUGWJ4IKxgobvdtB2yzNbtuYGahmbuL6cmH51eiExi2sCCnW8sSRCUbzB64iPHPKwsfwGhUBS7kFMsp6t5u2EI5RvhLNvkz1bT7X3oSoOVl/RzYss8lI5hJmZJzdeY+JwXf5vARJosWXrcpt3sjcMLafWu6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=e5/8dXii; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2d3baf38457so2231734a91.0
        for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 11:24:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723832677; x=1724437477; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4RwvB+WPYoDnWK8A0tq8EiazLJfKL2CtNS7fQiVukC0=;
        b=e5/8dXiiuMVZ22VqZ7YcGmesNeG11fTVq1KX2B9gjOPL0XSpPiiErM3Nm55y+QCGTF
         t+3p+o2v7oEPv89Z/okNk0MYa6gM3qRVYkM+9dRnP5E16MfQaIUN8/IWrBBm4mJbZ7KE
         oWSjvlszLq/bp/C2PEAgsAgyMtD5WhnoDpWOZp53HjvfisDMl6h6O3cFaPjLYs7QcVUN
         HgsNZNW0TpApEDjjA/eczHPr/eksgTFMpAVX3uLEUHc0jfnIp4plgyN4LaK8isA6ESR3
         DdqNEgBIJ1YUFyBSOox0fHT1WJEMnH8L55RZ90xgSTWdTDV3GypoQhQE35cm4vhCQG6c
         Q0ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723832677; x=1724437477;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4RwvB+WPYoDnWK8A0tq8EiazLJfKL2CtNS7fQiVukC0=;
        b=ggGpPpajYaE9dC5H5LtEQfQC5SOhMK6ahYen8WCRy2kfzDk/77mS69EHaEgrMEej/+
         7HptJVRMXfwQ4ZOrmsUQHmyi3s9fv7ZEhVdKRvTrCWNMoyfPOVltguQ0v8VCGTLZtRmk
         xLs2/o304J4lMINlPlVBOmhan0S9f6CcZQI15lj9BewLSDJ8TXNnWJGfEbN1Woi1tNs+
         qvKG3/nT/rSPOvnbkhf76O0n67H7JGNV7coFeQK+Qnpn3MCg0Ifs/Su3jFFEO21NVTVr
         7k5pEekvj+PAYSZ6Vh7CYD1HzKJToTXkdpUEn4diHN36P14LLsl76yK4RwEgiEdOyRIB
         n2vQ==
X-Forwarded-Encrypted: i=1; AJvYcCVxpdSWjZra1SoPqLyiBTEhHxYd09k/p7SD998aqyq4Hkh3Ly3MskyRguWkCeWMXQpn7wHvL7Fa4ZfnmaaEj6AGMOhL
X-Gm-Message-State: AOJu0YyARnNe0iOqWil3SMwCJYB6kbBQHh20qF9FjGqj5c/qhTlGCLA1
	I4f8jyU3Sdr+5qcgzaFI66KaZTfEexeL9bauVCTUKRdxsBJR5Nq6UDgiT1vCFGROPnsyL4ecbae
	3xg==
X-Google-Smtp-Source: AGHT+IFTs6mafYXYQyMdbVzMHx30DteW5lbCrThkaAk8B3G1fl2Zt7Rvnd8UnKlKrq/X37xDttudYA8SWrg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:1906:b0:2c9:5ca5:4d20 with SMTP id
 98e67ed59e1d1-2d3c3723c6amr46011a91.0.1723832677231; Fri, 16 Aug 2024
 11:24:37 -0700 (PDT)
Date: Fri, 16 Aug 2024 11:24:35 -0700
In-Reply-To: <0000000000006eb03a061b20c079@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <0000000000006eb03a061b20c079@google.com>
Message-ID: <Zr-ZY8HSGfVuoQpl@google.com>
Subject: Re: [syzbot] [kvm?] general protection fault in get_work_pool (2)
From: Sean Christopherson <seanjc@google.com>
To: syzbot <syzbot+0dc211bc2adb944e1fd6@syzkaller.appspotmail.com>
Cc: Jason@zx2c4.com, davem@davemloft.net, edumazet@google.com, kuba@kernel.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	pabeni@redhat.com, syzkaller-bugs@googlegroups.com, wireguard@lists.zx2c4.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Jun 17, 2024, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    2ccbdf43d5e7 Merge tag 'for-linus' of git://git.kernel.org..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=16f23146980000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=81c0d76ceef02b39
> dashboard link: https://syzkaller.appspot.com/bug?extid=0dc211bc2adb944e1fd6
> compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
> userspace arch: i386
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-2ccbdf43.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/13cdb5bfbafa/vmlinux-2ccbdf43.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/7a14f5d07f81/bzImage-2ccbdf43.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+0dc211bc2adb944e1fd6@syzkaller.appspotmail.com

See https://lore.kernel.org/all/Zr-Ydj8FBpiqmY_c@google.com for an explanation.

#syz invalid

