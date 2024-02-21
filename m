Return-Path: <kvm+bounces-9335-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4396285E51E
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 19:03:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F24F02852FF
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 18:03:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B5B885282;
	Wed, 21 Feb 2024 18:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iWU0WSJS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f50.google.com (mail-oo1-f50.google.com [209.85.161.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5AC283CDD
	for <kvm@vger.kernel.org>; Wed, 21 Feb 2024 18:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708538579; cv=none; b=emk9BMwHxvcaQsLPVsBw6rWVgkBCB6792UEG8V7EHuVaP0DG9Zd86PGR6PL6ZE7+5PK0ZNT+u3xhjEt3GWgcRgPS/Zy+dYYQ3flAeiIv2F69CYvzVZXozNuFlqio7J0qh1yahL2DYqISGCkBz18usuCmNO5SAnBJPTwzmLWs2kI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708538579; c=relaxed/simple;
	bh=f50Ax/Ki9ypHvi/OoLjeYscpFnsuccpEfRX/UYWAmRw=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=ZcPtDdXTm19Qk4lRnzYyDt8w1sAZisZtt/LopRNdEE42D20kNiYIg2kFwQwpG6LqE+KO+jADPqnm9+VG/+TnacOF8oQv+eslXgSCorCMUEC89RbVzKET9E2VqKqXaJ409+H0C3+NnP0G1EA471e0qTCibeMgasl+cfxtKWbpt4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iWU0WSJS; arc=none smtp.client-ip=209.85.161.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f50.google.com with SMTP id 006d021491bc7-59fc2666815so1571184eaf.0
        for <kvm@vger.kernel.org>; Wed, 21 Feb 2024 10:02:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708538577; x=1709143377; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=f50Ax/Ki9ypHvi/OoLjeYscpFnsuccpEfRX/UYWAmRw=;
        b=iWU0WSJSb6fecIJQQxOrcCv55rGHQk5t+7TZ5e7ibdjhDZkZ/UeEr4B4Ap02LuwCyO
         lWN4Hh/kKbOAuY6nzN3FT5pB82nodsZuCkHtHLGCm6dEOUAogUwHslwzNoo45KD57MmE
         XSZkSz2nhmhc2FqUHVDqdMRHrfG+jxcq0jMzDRrsoUz0WAk/5gIbph6D67ArnGwhyqfM
         TKNxJ0KhpxNjhMP9jw61Weqtn3kPB/Yk7kGmbqWUXn4T0A791TWD523zhPrs4Pimm9W/
         LO8hfEGGq9fnN9P5H4cppQ3T+6Zzs9UoxlV4pq1Sk0JPzWXfntV/dUzG0fdlNQamPk8+
         wIcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708538577; x=1709143377;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=f50Ax/Ki9ypHvi/OoLjeYscpFnsuccpEfRX/UYWAmRw=;
        b=dXY2GzKsdQ5rL5xZyPft9SFJ5YJVuR4A4cihH1WhZstc2qUdR5JTukPJBegQabVAv0
         qjM3CBLyyVuKCx/JVmMsW7LRHmegEB2Tun4jhOsUOpE1rvVvzgLpNT+9hSPPBishn+Cd
         3dJnqdAAT4oaClGBmz0OgeVhhDLZLwMWJF/B5WD8zHkRdLVpQoC6cBWYL2YGVK42GpQZ
         qEuYR4ER7TyF1iNdHjwuVQk/+rdIgcAesc5/ZoqPzmrCYIzRGf/mQ+YHzyDNheHhPUdl
         bxQZm4L1mgokXYdLcjkanE2Udfk2s1kYOCX/n07oqJDCp/tg+FQu0LQQTC0JlPR9XNSy
         M2qQ==
X-Forwarded-Encrypted: i=1; AJvYcCVifjVCairgiD+LYk5xZqXTgqBmELcoBOcDz3JqVUYmPg/mMERdZHZO4kTLcJ3J4sJzigUYKm8DoBYPqeK9hDmTmmGc
X-Gm-Message-State: AOJu0YwrNQuhY0sOey37K6ts1ZC4JfQ0z9AzDMOXywMaJ4hAp9fl+xIU
	utWNs1zxkNs6H6+MIyBUXaHVSpEHUN/QGynhNVyoME+BSkcygXHY4Q2zZOwqnS9CjzM+PREmkqx
	V05bqAcaLxC7x9EKqDDEqinmIFVMOLSuIgp0=
X-Google-Smtp-Source: AGHT+IFp4Qa6H028v9husRiSLKomrplARZa2a7qZgkaKSSubq94NAwfSYMpY2fFko5JYenWiT5TiFEHuCT/iz6XiDMk=
X-Received: by 2002:a4a:d5cf:0:b0:59f:f90d:49f0 with SMTP id
 a15-20020a4ad5cf000000b0059ff90d49f0mr5547926oot.2.1708538576727; Wed, 21 Feb
 2024 10:02:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Stefan Hajnoczi <stefanha@gmail.com>
Date: Wed, 21 Feb 2024 13:02:44 -0500
Message-ID: <CAJSP0QVs3W7MOMSdU0G8J1=AufwLGp8K3SGUGxHUDyjEWu9LpA@mail.gmail.com>
Subject: QEMU was not accepted into GSoC 2024
To: qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Dear QEMU and KVM community,
Unfortunately QEMU was not accepted into Google Summer of Code this
year and we will not be able to run the projects we had proposed.

This will come as a disappointment to both applicants and mentors, but
please read on. For applicants we encourage you to look at the other
great organizations participating in Google Summer of Code this year,
like libvirt, Linux foundation, or AFLplusplus.

I have not had detailed feedback from Google yet, but at first glance
this seems similar to 2012 when QEMU was also not selected. Sometimes
veteran organizations like QEMU cannot participate due to the finite
amount of funding available.

Applicants can still contribute to QEMU outside GSoC although funding
will not be available this summer. Don't hesitate to reach out to the
mentors for the project idea you are interested in!
https://wiki.qemu.org/Google_Summer_of_Code_2024

QEMU will apply to Google Summer of Code again next year and we hope
to work with you in the future.

Stefan

