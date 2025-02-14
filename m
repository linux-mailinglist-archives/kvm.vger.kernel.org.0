Return-Path: <kvm+bounces-38139-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 52E7CA35650
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 06:37:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 155C116AC9A
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 05:37:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FD7C18A6A9;
	Fri, 14 Feb 2025 05:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=j4q.cc header.i=@j4q.cc header.b="p5203O8x";
	dkim=pass (2048-bit key) header.d=purelymail.com header.i=@purelymail.com header.b="K1AAQVFE"
X-Original-To: kvm@vger.kernel.org
Received: from sendmail.purelymail.com (sendmail.purelymail.com [34.202.193.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAA9338DD8
	for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 05:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=34.202.193.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739511454; cv=none; b=Iokd8U4dDwsmRTUzewyguhETTsmDUZa7r2xDq3j/ntM4v0pLjcWsoV3CMSMTfmclG861elfyHx6513fICmxxLYgvF+gaFh74wz7aLyKSIkG4OrWz91TINVdgeLsv3+7jK8yR3B1yDhi57MBLik0xFHBI1fPcSx7hnc87UIZW0/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739511454; c=relaxed/simple;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=M9wGnZ+Rv09XqxV0aUhUpOavnx/0z8VsDgTMSdVnYc10PMO/A4sdSxHDdGFNNYBzRaIoUSh+Q+0HUsGffZWy0LHDP3wF8uBrmAlgfp851Rtk3pxiSkWBefRo4+YvJxFPdmsByzNfPvpksvQIU3A2YZz0E0pNbYEUTBqHA7ivAS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=j4q.cc; spf=fail smtp.mailfrom=j4q.cc; dkim=fail (0-bit key) header.d=j4q.cc header.i=@j4q.cc header.b=p5203O8x reason="key not found in DNS"; dkim=pass (2048-bit key) header.d=purelymail.com header.i=@purelymail.com header.b=K1AAQVFE; arc=none smtp.client-ip=34.202.193.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=j4q.cc
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=j4q.cc
DKIM-Signature: a=rsa-sha256; b=p5203O8xP2stv3FyOVM+bm9H/SG0dyQj1/uQ3N3oL+JJszLGsRkbqHKGdPowMEx390d4wpHUrY3KJ7lUEowOsMGNpGhIWMzfsA1BMPLz7peTSbca0Wu2Bs2clNbVRL2/+afTrP4handUCpjvQEvdXCfM3TQIgr8BVEyj123Sis5DKTXHuXBC7wB73LPdBFEJZiWzipbh3ShjGx5ESQT7aC775r1UcZEJtN+WICnv1QBntD3tMO2CzMlV4z3iia2xWL1KNE4SrrNO7pG2c/smRdAwharI6SeD5MTtCUNpN6bS8XH98aH5++x7jcmc5NLFNw9pLVdakmSIf3J7q8Rnqg==; s=purelymail3; d=j4q.cc; v=1; bh=frcCV1k9oG9oKj3dpUqdJg1PxRT2RSN/XKdLCPjaYaY=; h=Received:Date:Subject:To:From;
DKIM-Signature: a=rsa-sha256; b=K1AAQVFEMBN6LsPbR/bUgRm0Qdx757E9q/SZHTWjZ2Sp4DFcpxnGMNR8hAMaET1iGX5a3yekTZUtWarFn8sEzF3OzHFAEvoi7ztorI3Q1M7J/3TJH9NPEndT9yXGrZIk2tEkABzY6VR+wDJ/asUCQl+QvyReRu3q/Hy8XW6wwM51VmEfoZjnCkijSBWkc9YnOY5WualGm8ZvvJFEdykvxLS8l/fw7eh79kk60U8uQnX9QZW90HBoUtO51mXGVlwVVVeNYd6vN4s+SXDgTbruPrO0v44CqF8vxbUiheJoD0oYWPWInBnhXsVm8fkQ0t+ADncA+TbEwXFiXtGNW0Vjeg==; s=purelymail3; d=purelymail.com; v=1; bh=frcCV1k9oG9oKj3dpUqdJg1PxRT2RSN/XKdLCPjaYaY=; h=Feedback-ID:Received:Date:Subject:To:From;
Feedback-ID: 22876:4246:null:purelymail
X-Pm-Original-To: kvm@vger.kernel.org
Received: by smtp.purelymail.com (Purelymail SMTP) with ESMTPSA id -639951769
          for <kvm@vger.kernel.org>
          (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
          Fri, 14 Feb 2025 05:37:22 +0000 (UTC)
Message-ID: <923a7216-4566-436b-8cff-871855c7814a@j4q.cc>
Date: Fri, 14 Feb 2025 05:37:21 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: subscribe
To: kvm@vger.kernel.org
References: <20250210092230.151034-1-nikunj@amd.com>
 <20250210092230.151034-4-nikunj@amd.com>
 <8ec1bef9-829d-4370-47f6-c94e794cc5d5@amd.com> <Z6vRHK72H66v7TRq@google.com>
 <858qqbtv6m.fsf@amd.com> <Z6yqeEQeLoTQx_QD@google.com>
 <f1476003-5446-4527-8a78-ce0ad478331e@amd.com>
Content-Language: en-GB
From: list archives <lkml@j4q.cc>
In-Reply-To: <f1476003-5446-4527-8a78-ce0ad478331e@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



