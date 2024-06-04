Return-Path: <kvm+bounces-18832-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CFD308FC018
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 01:44:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6EDF3B23C7F
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 23:44:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F206714D715;
	Tue,  4 Jun 2024 23:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iLsutP+J"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1D6214BF9B
	for <kvm@vger.kernel.org>; Tue,  4 Jun 2024 23:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717544662; cv=none; b=kv7tCvtB31fl7MvL0Yow4qAnwL4LKK1SZIXI0ib+P0MTBnrvRbZQobSQprQ6n0hDp7xTdOFAW6pl0/7HmVVckkMtvekpCjWUEdP6GOG26VlZWkOQgoFMWkuHN4JNskHFocf1zV2sGE/VXi2OjavIzTb4wREV66gUo9u8FqIQHCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717544662; c=relaxed/simple;
	bh=QQEipxczhKxMeqAerAk9cuCuFkJs4dsAjrvDJ9VyOQc=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=B+I0AtLz3TLJh2YjMCUWZpEhQUTs4LUbUPcjX/IKXcZK7DNAKt8y55w0TXqBThg6j9w0IxwHQUJHuE8JiXlRYmakn8w9DPozScDsUOaX4qh7KYEIPendsD2lfCAZLyIdHRO5IjRJiqQ2ksuwubeug2eTGh82pUxGcnH3imwtHR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iLsutP+J; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-70287dabc59so1143645b3a.2
        for <kvm@vger.kernel.org>; Tue, 04 Jun 2024 16:44:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717544660; x=1718149460; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zXka6xs5J98hAhwP/nPGzpBh6FnBKZVWPkF0+VSsNlo=;
        b=iLsutP+J/R3OcHHztnnLB83tv3Ty1mbeLccyYqiIcKKLBJj15NNRVyDsKGaSJJOd2M
         hgvEqd4l48mM7If5Fa16R8AzCZbjCMubOu2HUMqWMOBypzZsssWJ7lfuuoD5h8QbSqG3
         2aOprpWs/aYsUkn73TTpQOaScFfg7YzM1r31InUDeMS1mTgacpdzXhXjGFcxbP6M39sh
         eiLcisP8zMZQijG106k5T99gt8YK2KfnsqyiteFyztorEb9OmBYA8iPmsK60teMXy5FX
         Vn6nWtD7Oe6uQaO/M6Rinb/7+LuhE2ADVEQMxsXZsNhdfy/w3bdAWAL88ouGTr9dfZx8
         rFWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717544660; x=1718149460;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zXka6xs5J98hAhwP/nPGzpBh6FnBKZVWPkF0+VSsNlo=;
        b=DJGBcxCTZQNUzgH8MrPxP7mmQdl1A8ISkpOrl3hoOG1Nn5sGRRSbR2+5vAjJLQC5oY
         nuDfQpTsUaKBWggu/gHedTc+0r1BgsqK6nbgI5ZDVuyKwyeB2CwJWA4GhGv+dABKUUpL
         YJwDWb2+CrdCbQ6S+j6ZjcnXuyeN4d0bhpEYc5yeIBGVdNn0zD7p/R+56ow2VykpqiXw
         4ytS7rKSepHXTwrWUJdKwgSi4Ja2fNWzes3GTdBmZAy5S1LrqGMXRQ8d44mo1neOgd7T
         IbCOxjPCteL94bXPnu6DYEcquuKrmn/yxHGWQgtL638CX1wtCIL4bU3llQjxZAXlRJ0V
         JX+w==
X-Gm-Message-State: AOJu0YzLMmYuFtHfD3O3a9ekxZ3liGIhFL6z6Ae6l60nEG688QYIzOKz
	R8ztcHDrucgyUXWi1uJjN4ZGeTDM7s6xz3nzpRduGgB+YAvCJXy6QYsSMgneMK2dBQO/yXKcv79
	u2g==
X-Google-Smtp-Source: AGHT+IGpwdiVAAddfEUylmbftcWBoLyyavVbcTJz7zvICqANd1MVzUAKR34rVo2VjfSrNLwUC8JOWYEsVjs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1146:b0:6ea:f424:85ce with SMTP id
 d2e1a72fcca58-703e56c90bfmr51928b3a.0.1717544660292; Tue, 04 Jun 2024
 16:44:20 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  4 Jun 2024 16:44:17 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.1.288.g0e0cd299f1-goog
Message-ID: <20240604234417.2782840-1-seanjc@google.com>
Subject: [ANNOUNCE] PUCK Agenda - 2024.06.05 - No topic
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

No topic for tomorrow, but I'll be online.

Advanced warning, no PUCK on June 19th or July 3rd (US holidays).

Future Schedule:
June 12th - PV Scheduling
June 19th - CANCELED
June 26th - No Topic
July  3rd - CANCELED


