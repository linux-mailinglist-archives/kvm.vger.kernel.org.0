Return-Path: <kvm+bounces-67091-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FFE7CF6A51
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 05:13:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 496EB3038326
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 04:12:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E96E827B4FB;
	Tue,  6 Jan 2026 04:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GU6Jdc4b"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C43AC26C3BE
	for <kvm@vger.kernel.org>; Tue,  6 Jan 2026 04:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767672777; cv=none; b=c6DkV5exqqK7B2FMp+Si/WUykKKnk1yu70tz1zOTY26/Ljr9PSuvSpOilLRny5zata52MaSvD79qzUxvkxo6kbbVPOz7cM1qfe/TkkHLKEWR+zLmrjuq01ORATBDInuuKPU/zIjAekIfmAB2JYyJgkmtoP7ZUUECn0o8FOPj3ZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767672777; c=relaxed/simple;
	bh=/gvhaYPwCpvXxA5BAYEaXPq10p9VEf+RX3p6hwx3rWw=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=tyobZT0WHQGzVOys0gSGPeI6xa5+HTfsKV/tRQbiBDG+rr3rdXXmJwoWuDl4tlf1UENYWXkYrrKncHLtDhtn0VglCtYMQWqQuXDBVH0x6GpK++iDrM1MmL1v70+48ytGlt9q3RIa+tI5f0g9Gvp/ZHDr3g+bmt0WXz5WXc1JutA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GU6Jdc4b; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-815f9dc8f43so1182710b3a.3
        for <kvm@vger.kernel.org>; Mon, 05 Jan 2026 20:12:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767672775; x=1768277575; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=8bO2RxH3D3Alpkfn/EAlJ4/QlkbXyQjaqL8DCAG5FfM=;
        b=GU6Jdc4bkallOeoDlSWSbJNlU5myjB9H20JYEIM4ewC0GCpIUxeoR03/tC8CqpWnD1
         Ax4OgFXBQEIosvzjCXXCB0/amYftPp5opZIFy7y6Aj4SM4SsPfU/t8QaVOE/Lp3uEq09
         JlfJFEEZP98fPnrttTbVTaSJ27T+uzgIIERznLK019/tpg9I/VdSR2xcWx/j5T6khxkj
         J/SZX6M3YLPXt7tdoWea4xkUe9PBbEHGTsVe4n96AKRUS16dfR4DZ/YxglBr7r2yiZm9
         tKQapRnoyyd+ExOYFnpveax/B8PTJ0WCS0POATuPd2REeO2u/ohPlVPcPA9uLQ/bbbQf
         SlCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767672775; x=1768277575;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8bO2RxH3D3Alpkfn/EAlJ4/QlkbXyQjaqL8DCAG5FfM=;
        b=kShlhhgFP8gEnsYnzA9Z9tJxbayTMQEw78IH52K9XIyoAh+5ZTsY+xwqvhLiSzPAxB
         Us5eT/V7UiUK8IHtKGHKLpwQc3iqnNf0+hBRrtvNxdAr1ZvUmK7WJY53uD3aOCSjAQlh
         axshv5YgysdwIO5ii1wbOhLyk/XDJxoBys/8pV0g41DIM50enjqZYFQlZOsbWArFDO01
         PYg4a36+YGBsRfVlWdGYYP9l+UMYWj+pJ+Sbt8fROc1gStd8fBG2PUaCNTg8S+1cfhAK
         a32IGO+u+FlWYp5GNoVF51zxbnKeVLGRXFMuzvFzxLxtYUsl9cczayVU6eR4e24KyHmq
         wd0Q==
X-Gm-Message-State: AOJu0YwDo3q5kEXrEcPtmo+NVyML/TKKDyrDxeEpBdUbtoYcilj+oOOd
	GmWHHMFctnJlYcok2hOHqwo9mYg0xbnD3e4u6gjEuWg8i8IzQvjEoYIyG0MhcgIfbt1uCVNhdNm
	jnoevif8lthj8UA==
X-Google-Smtp-Source: AGHT+IG1pp40YNhQAPBjufXd8JnGqBmu0CqG5BPG/UL4lB+QRuhuVzfr+72eXDweD9+4CrvY2q6pd26uBjnniQ==
X-Received: from pjyt20.prod.google.com ([2002:a17:90a:e514:b0:34c:2156:9de7])
 (user=chengkev job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:12d5:b0:366:14ac:e207 with SMTP id adf61e73a8af0-389823cbc9amr1214150637.69.1767672774767;
 Mon, 05 Jan 2026 20:12:54 -0800 (PST)
Date: Tue,  6 Jan 2026 04:12:48 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Message-ID: <20260106041250.2125920-1-chengkev@google.com>
Subject: [PATCH 0/2] KVM: SVM: Align SVM with APM defined behaviors
From: Kevin Cheng <chengkev@google.com>
To: seanjc@google.com, pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, yosry.ahmed@linux.dev, 
	Kevin Cheng <chengkev@google.com>
Content-Type: text/plain; charset="UTF-8"

The APM lists the following behaviors
  - The VMRUN, VMLOAD, VMSAVE, CLGI, VMMCALL, and INVLPGA instructions
    can be used when the EFER.SVME is set to 1; otherwise, these
    instructions generate a #UD exception.
  - If VMMCALL instruction is not intercepted, the instruction raises a
    #UD exception.

The patches in this series fix current SVM bugs that do not adhere to
the APM listed behaviors.

Kevin Cheng (2):
  KVM: SVM: Generate #UD for certain instructions when SVME.EFER is
    disabled
  KVM: SVM: Raise #UD if VMMCALL instruction is not intercepted

 arch/x86/kvm/svm/svm.c | 43 +++++++++++++++++++++++++++++++++++++++---
 1 file changed, 40 insertions(+), 3 deletions(-)

--
2.52.0.351.gbe84eed79e-goog


