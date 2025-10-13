Return-Path: <kvm+bounces-59889-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C30CABD2CEF
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 13:40:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 414F13B4607
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 11:40:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFB2826158B;
	Mon, 13 Oct 2025 11:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Tv9lr7Qm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02E7625FA10
	for <kvm@vger.kernel.org>; Mon, 13 Oct 2025 11:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760355646; cv=none; b=uH/1sEhVMh+vn+o5E17qLLjc+fqG50Y03PRIsWxXXQ9a419hmVF967R6J/Aa3ofDl1NtT6Hn/atm3ErYwLKz9ugeCazBmacReGLcwUbr6LDkyatja0tPNy8mA39ibvDEpGIb/HO8hEUI8V9zTcn5PRlNkEaGLWoO5CHn27KayNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760355646; c=relaxed/simple;
	bh=alf63Pzxts5J+gihJoMEHOEyfgclydhU0zJKK8E74wI=;
	h=Content-Type:From:Mime-Version:Date:Message-Id:To; b=gA7sCdqap6j7+iRlJZ7uoxfIUF3DMVxwqj2eyl77nBZ1U4ofjbi77K9ru6xzkXOSdAyVpxTYbkSc4h6lMd2Ojp02guKziv/m13QjbPV6st8mzoN+OzE7Q4OCLhq6Y5ZfX66dPdeU/l3sZBRiKdZS1RTE6AwMfvuKQKZQt0KP5+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Tv9lr7Qm; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3ee64bc6b85so4579250f8f.3
        for <kvm@vger.kernel.org>; Mon, 13 Oct 2025 04:40:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760355643; x=1760960443; darn=vger.kernel.org;
        h=to:message-id:date:mime-version:from:content-transfer-encoding:from
         :to:cc:subject:date:message-id:reply-to;
        bh=alf63Pzxts5J+gihJoMEHOEyfgclydhU0zJKK8E74wI=;
        b=Tv9lr7QmJuj3bNVMYmllSI5q7CJralDIWor7asbiGo4zBHlrAEy6fHou/tMkYIHNXz
         SdcwfAY2jkRAlc/0lvIFffRUSr4277TwNBsW7xyjmIvt+5nNZ5WFY0rWNRwIbRjViYvW
         yk9vLCozomTurHziCEVNpovj9s0+o/hio6irG6FAaQSRJK2X68n/TBmXps4SSHttyLO9
         gFs/0hgghJhYlhkhzQGlSxwmUPbEq6yUBdbga6pp1zpeFEXtLdovgHjPuhG464knBoXj
         O46RE3t0+w+aTnQL9vsx07AKXPGMrqjvozAxELLZYx0Kl2iThOkV+UPlTxoBdGP5pn2e
         QnUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760355643; x=1760960443;
        h=to:message-id:date:mime-version:from:content-transfer-encoding
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=alf63Pzxts5J+gihJoMEHOEyfgclydhU0zJKK8E74wI=;
        b=nSVdtr9UHKYhSbPw5DXUctVYv78DojfoeZn6al+eHIbcOAI4MDBn6+TlAVleN+ImQg
         emsBssqo7VFwwrIsbsVcEMqF5WuhqCs+yyhWV49t0YHazULTBzf+R9+rOOVBEX6X+uYq
         gRx3RFRhHWgYAJw5Nrs41zzhMwlS7VzLBUvhz6VvCklbgW5cfzP7TkMHuxGFU0zYU0fz
         qlE8zyFwfHLPMwy6iafm0+zi3gkH0JQz2w7ZsVOee13PhcTGtN80MNpred5cYZZNiT+X
         hSi8vuFlAalKRjdE/GWZ4kPo7iQuWWHz/0c+ua4JiIpdLybFIafzGnpU+Kvy5znDm8j7
         QiIg==
X-Gm-Message-State: AOJu0YxptaIpyJNxl/imgInAZGq9FgLBKfOw1vFQjF76W5ZVxKjrcnMS
	TCzHQea8GTUw/Gtxe+LOjwHSFQ/OV9GSt5VnUWXdF3rvJfvN18eVrYk8Q8rk4A==
X-Gm-Gg: ASbGnct5Jh31Dj2boDWw5vj6to5gzKTnamwm2E0An6+IBQC+caFOoDPsiFHLgcaZva6
	+4NE0/YuZZPCOYHavMWK0t2ddb6KgighyKPtZrsYar9tDUMhSnmLOng+69imnwost4pXPTL/ic7
	4NVMuXhHR8/IyDV+R7MLjHeNe4VtDNdptFXWnM93Ex/iHaRasZi9CiSkFfUP3P8SNvw0drFldEO
	NQxwbykbF+c28bWmYmaFUGJUE61jJWZzacrwDGiZJIeRE2AD7bLh8LHwORIVvAo9iFswshrTy1G
	Kn+6PpCMxy1bPlWo7WE8bdhTHKLFErO021l+lf3ilVwUGw7mfQC9ijsdCI75NBPZKmQ4BjzEEpJ
	WAzjCd+SKCmlU3IYbu+RXqE8yZWn/BT4ZFLYG5cgy007H4gHAn4u5MhWZ255Lh44fJzXxt9vkwq
	GAIpq7yZqXIQwgyg==
X-Google-Smtp-Source: AGHT+IGHwN08Z2CSRmav7/dq4KrM1R4XFPDv0M26q73GZrIU5E6ElazbrSbY///EHnL5rMvevGReeg==
X-Received: by 2002:a05:6000:2003:b0:3eb:5e99:cbb9 with SMTP id ffacd0b85a97d-42666ac410emr13524780f8f.10.1760355642908;
        Mon, 13 Oct 2025 04:40:42 -0700 (PDT)
Received: from smtpclient.apple ([2a0d:6fc2:4a60:2000:4c46:578e:450:db03])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-426ce5e833dsm17942940f8f.53.2025.10.13.04.40.42
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Oct 2025 04:40:42 -0700 (PDT)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Idan <idanspevak@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (1.0)
Date: Mon, 13 Oct 2025 14:40:31 +0300
Message-Id: <6C8F8B87-EDD9-43A8-A8DE-C18A4D33C2AB@gmail.com>
To: kvm@vger.kernel.org
X-Mailer: iPhone Mail (22G100)

subscribe kvm

