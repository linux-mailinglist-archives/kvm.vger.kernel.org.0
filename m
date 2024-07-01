Return-Path: <kvm+bounces-20808-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D1F7B91EAB9
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2024 00:11:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D538EB20C55
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 22:11:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26AD616FF48;
	Mon,  1 Jul 2024 22:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FHmvvequ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 110C44F602
	for <kvm@vger.kernel.org>; Mon,  1 Jul 2024 22:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719871906; cv=none; b=JC/6BWAn9ybFdLKZmQLiV5FntcGEP9FExCaEnw1BzDpL+EfjwdnwjWGndbGG7k15lP6SXcxCrd8mmGdAPzHBkKjZpZHo7qU8q8bfAuTh/aqAxKoXi4T2nUA3KJbRMZsIaOY9wvKHQmLcf6U66UsJlw4FO+D2I3gRbpFQSFqb0eQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719871906; c=relaxed/simple;
	bh=rua7BVUB770KdYk+Lg9OGHMztp9N1Qhe3FMIIJtwvrE=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=KAaXm26PJXSVNI6bN/KxbaxXD9/aHY5b1/gozXzxYhMlqymzEmkSqFLSWXKrcqw4pX21Dz+QxHw0HX4BoVlBlxuo/2q2ga4P+5vsL7Yabpl1MYuwgq4h7VINAc4fPXYgxwqdSuBptsyO1onHo/Oij+o108Lf50jRapftZstHV54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FHmvvequ; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-6bce380eb96so2048994a12.0
        for <kvm@vger.kernel.org>; Mon, 01 Jul 2024 15:11:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719871903; x=1720476703; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=C8Mv8A1KG9qigkoJE9sluc63trlyLSvzFknrEBJmKIY=;
        b=FHmvvequryjR6NHvGE7B5PPdIrMtha7EyPF4j5MiX5oRE5rxEFnnR5eX7xwx+m6tjN
         hFaWznXC2w48kzFVR4UeDpwQx5g9uKVBwKdDITBY5V/sgzXcr3lQ3byGUX2EUS6ebsnp
         coyXbRODW0wqwF4m+6a4lir6/QkCqtCo7Yb65GRbcpwlhv0ccoQG7jZCLJX7E3CswkJm
         2IxpmkRmGg3SYdepV+yhccWLRHUFkfxhjzT52vALdTSXkXKRpfGKJFkSIGqPRmuvuwf4
         6M8uhI1uJn8JU56Ixg5nph+kiZfM9dMvwx18x8mIozer4JbqBrnCmtWodcdIdWQWvW8O
         BY9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719871903; x=1720476703;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=C8Mv8A1KG9qigkoJE9sluc63trlyLSvzFknrEBJmKIY=;
        b=JVg1e3F0VIe3k09f/60UelmZMVHCs8U67Tn+0jMUAGJg4V58cxuyeraIpoztHafZpN
         B2UkaUpHxB7zVH/kGzn34lOYPxB4iApAj4NNooWXWuhP143nix/n026rBJ2+SsXBn0Zy
         kAlhQruSL8xy6eJBmdMhAeBLydNMpU5kePVjPE5SLextTNi0qFMV99DuJB13rrtvLjbd
         WKI/2kny3i4Y3ukr8rHjfftcKdDiOGMSvzOCuYWtB7ysFj/usgmR4ZH1TY3Uck9usWR/
         YadHWV3xCswal4Of2dUYfwgLja6yhJJZjOVknLSarIJWlZxg1WE9/u+qz7HgY8XCyqCD
         ofSA==
X-Gm-Message-State: AOJu0YwtPne73gFAVJht54WqlUthJ9glJ6cA7rnpFppuu+s6PBAEojEo
	0V6LxvNqkJA4iY8TUyvEsmKnjAiWaeYm6k4VivKfquektHqarJpxj5mK9RvtV09sCz44D6Li57w
	JMUpATLCqiw1wscmAWHG3AMIu5ejBXi+htMrOww==
X-Google-Smtp-Source: AGHT+IGtSOFi/6cawkpoPcq8rwNlFQhzgmUlHtcTOQwO6Xv3lDPtek+GN7zEmHp+Dl2rpiGaNJyMW2BG8ThKpWCaulY=
X-Received: by 2002:a05:6a20:cf84:b0:1bd:212d:ac5f with SMTP id
 adf61e73a8af0-1bef6206706mr5411469637.39.1719871903358; Mon, 01 Jul 2024
 15:11:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Hongyi Zhao <hongyi.zhao@gmail.com>
Date: Tue, 2 Jul 2024 06:11:30 +0800
Message-ID: <CAGP6POKJQH+QpdKV_kBb3ykJ7bZpzoM0nHmS_1Cax=QJ0kO5ug@mail.gmail.com>
Subject: Failed to optimize the host with tuned.
To: kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi there,

On Ubuntu 22.04.4 LTS, I try to install qemu/kvm according to the
guidance here [1]. In this step [2], I try to optimize the host with
tuned as follows:

```shell
$ sudo systemctl enable --now tuned
$ tuned-adm active
$ sudo tuned-adm profile virtual-host
$ tuned-adm verify
```
But the last step failed as follows:

```shell
werner@x13dai-t:~$ sudo tuned-adm verify
Verification failed, current system settings differ from the preset profile.
You can mostly fix this by restarting the Tuned daemon, e.g.:
  systemctl restart tuned
or
  service tuned restart
Sometimes (if some plugins like bootloader are used) a reboot may be required.
See tuned log file ('/var/log/tuned/tuned.log') for details.

werner@x13dai-t:~$ tail /var/log/tuned/tuned.log
2024-07-01 22:39:07,549 INFO     tuned.plugins.base: verify: passed:
device cpu71: 'governor' = 'performance'
2024-07-01 22:39:07,553 ERROR    tuned.plugins.plugin_sysctl: Failed
to read sysctl parameter 'kernel.sched_min_granularity_ns', the
parameter does not exist
2024-07-01 22:39:07,553 ERROR    tuned.plugins.base: verify: failed:
'kernel.sched_min_granularity_ns' = 'None', expected '10000000'
2024-07-01 22:39:07,553 ERROR    tuned.plugins.plugin_sysctl: Failed
to read sysctl parameter 'kernel.sched_wakeup_granularity_ns', the
parameter does not exist
2024-07-01 22:39:07,553 ERROR    tuned.plugins.base: verify: failed:
'kernel.sched_wakeup_granularity_ns' = 'None', expected '15000000'
2024-07-01 22:39:07,553 INFO     tuned.plugins.base: verify: passed:
'vm.dirty_ratio' = '40'
2024-07-01 22:39:07,553 INFO     tuned.plugins.base: verify: passed:
'vm.dirty_background_ratio' = '5'
2024-07-01 22:39:07,553 INFO     tuned.plugins.base: verify: passed:
'vm.swappiness' = '10'
2024-07-01 22:39:07,553 ERROR    tuned.plugins.plugin_sysctl: Failed
to read sysctl parameter 'kernel.sched_migration_cost_ns', the
parameter does not exist
2024-07-01 22:39:07,553 ERROR    tuned.plugins.base: verify: failed:
'kernel.sched_migration_cost_ns' = 'None', expected '5000000'
```

Do you have any tips/comments for fixing this problem?

[1] https://sysguides.com/install-kvm-on-linux
[2] https://sysguides.com/install-kvm-on-linux#6-07-optimize-the-host-with-tuned

Regards,
Zhao
-- 
Assoc. Prof. Hongsheng Zhao <hongyi.zhao@gmail.com>
Theory and Simulation of Materials
Hebei Vocational University of Technology and Engineering
No. 473, Quannan West Street, Xindu District, Xingtai, Hebei province

