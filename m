Return-Path: <kvm+bounces-17732-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AC5698C9065
	for <lists+kvm@lfdr.de>; Sat, 18 May 2024 12:18:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DB9081C2100E
	for <lists+kvm@lfdr.de>; Sat, 18 May 2024 10:18:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FAA12556F;
	Sat, 18 May 2024 10:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AUMQswmV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7BD0946F;
	Sat, 18 May 2024 10:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716027473; cv=none; b=VxGracI0AtdOf4U1vo/0qDBMtKtY067T1LU324fZOO/BElfuE1LDlcQSyLHUGoIGEQfbO1Ko7CplMhU4L3Vxn2G2b8gUGo+8UKjDIhwnV1tqIcVfAjslfoW24yBj2dbgd44loQhHX4awu8MsLZO6nPaX/xG0t7xI35XBmjHG6hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716027473; c=relaxed/simple;
	bh=xA2Bf8n5RCyqeoXlRG/S9pgpV9kOGAQ4TBNdrifLrLg=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=iVA+hFtp0+VYSaPbSnDkJ30ljvbVvmaeo9e9boULm5MDoFBlA3TjlK6zjmO6HC8cAv1q1V92C7SbQBhhJZxxQIThOj5gIxy2PmuGZhpMPSMpJx8nltJ9ydMPfv6QQPxeYsqjvmITdN26mLQwJH7bv+gW8rD0T3+IO8/i/ZBWw0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AUMQswmV; arc=none smtp.client-ip=209.85.208.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-2e3e18c24c1so30473391fa.1;
        Sat, 18 May 2024 03:17:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716027470; x=1716632270; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=xA2Bf8n5RCyqeoXlRG/S9pgpV9kOGAQ4TBNdrifLrLg=;
        b=AUMQswmV9UU06FcWmNpLQG4c/1nMBaQnDs3lZ+i9RObRo3Y2wSZx1m0nnhAw8Df9av
         9aGYmcvP3SDqc4sC2d9LS0ar2ztfg3tYYr+XZP4KEDWVK3StvNPYCHAH7l/3Hjgjdtur
         T08YSws443IcXGxqfIhhEmmGrEi/pcNr25mMTacT5BPmujh/gCEleOZZACpUoVNIdEuC
         oP8dBpiWp69rvngQcAWXUy+A+EYQx++Bi5L+Z3sH2fqOW/sf+ic1/hyKun3/S6HApUpv
         b9f8qNO2c1hTonK9DUzM75k+F30gWoJRpI4SCLB3exrZGlpxmyJoJ0cJBrnqXuT5vyRt
         BvMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716027470; x=1716632270;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xA2Bf8n5RCyqeoXlRG/S9pgpV9kOGAQ4TBNdrifLrLg=;
        b=P3dXKQ1szIPaCrfPdAXqhvqneCv85VnHYvcqwXNBmUZtVA+l7qNZvJwvBFzVxO2dN+
         93RU2eYxwUEd2fL7O1diMqG5jwn13GHy7VjdmDUfS6OGz6Ageq8BSmTH4U5iuhiotUyX
         ouLxufr5jLSUyzv80jxhMK4nv872x1glb2Seg4e5vw9vi/+buKc3pcDMywghnVHck3aN
         xwiuanXA1z6x0Gj/+xr7xcJtm9buNShS0qn1OWABscwppSmc5B6Xb+CZCtdWKrVwE7WC
         ZXtm3M3CTuqlQlAAc3mTXnf3ETWSly4b7kR+RSqmb2tNO0zlkrZtjdrBeiIYfv8W4tdv
         GSxw==
X-Forwarded-Encrypted: i=1; AJvYcCW/wG8LYY2cRf/Xu3QhobQuxO16i7U6hEZBP5jg2teFnOuiBJfxf5gtGE3wrLkDAZiwz+NYCLvt06z2CAqFFH7lcOz4jFrS
X-Gm-Message-State: AOJu0YxXY5uo90kwRJFWSRfTOHT3WfUiysOnmaf3ShY9Xj/0vGg9qdwj
	mE0OzaO4Yc7rXk7Oaodz7iGLKvdPIQwXk0z0ykLyNdplhat7fC/HO7dYW8D8IGu3CLmN6Y3i5j6
	fkCQTzAPA5854GkbRSeTxRJ+HjSc=
X-Google-Smtp-Source: AGHT+IHdD80bucwwGfBvIzB+/cPOI8ABdlz0Zfb6O/bBatrsEmQ3rYLNrEXm0kKzesZxrgLoHZ0g9pPzIbQuxQvAe+E=
X-Received: by 2002:a2e:9284:0:b0:2d7:1a30:e881 with SMTP id
 38308e7fff4ca-2e51fd4a537mr167836001fa.12.1716027469622; Sat, 18 May 2024
 03:17:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Dorjoy Chowdhury <dorjoychy111@gmail.com>
Date: Sat, 18 May 2024 16:17:38 +0600
Message-ID: <CAFfO_h7xsn7Gsy7tFZU2UKcg_LCHY3M26iTuSyhFG-k-24h6_g@mail.gmail.com>
Subject: How to implement message forwarding from one CID to another in vhost driver
To: virtualization@lists.linux.dev
Cc: kvm@vger.kernel.org, netdev@vger.kernel.org, 
	Alexander Graf <graf@amazon.com>, agraf@csgraf.de, stefanha@redhat.com, sgarzare@redhat.com
Content-Type: text/plain; charset="UTF-8"

Hi,

Hope you are doing well. I am working on adding AWS Nitro Enclave[1]
emulation support in QEMU. Alexander Graf is mentoring me on this work. A v1
patch series has already been posted to the qemu-devel mailing list[2].

AWS nitro enclaves is an Amazon EC2[3] feature that allows creating isolated
execution environments, called enclaves, from Amazon EC2 instances, which are
used for processing highly sensitive data. Enclaves have no persistent storage
and no external networking. The enclave VMs are based on Firecracker microvm
and have a vhost-vsock device for communication with the parent EC2 instance
that spawned it and a Nitro Secure Module (NSM) device for cryptographic
attestation. The parent instance VM always has CID 3 while the enclave VM gets
a dynamic CID. The enclave VMs can communicate with the parent instance over
various ports to CID 3, for example, the init process inside an enclave sends a
heartbeat to port 9000 upon boot, expecting a heartbeat reply, letting the
parent instance know that the enclave VM has successfully booted.

The plan is to eventually make the nitro enclave emulation in QEMU standalone
i.e., without needing to run another VM with CID 3 with proper vsock
communication support. For this to work, one approach could be to teach the
vhost driver in kernel to forward CID 3 messages to another CID N
(set to CID 2 for host) i.e., it patches CID from 3 to N on incoming messages
and from N to 3 on responses. This will enable users of the
nitro-enclave machine
type in QEMU to run the necessary vsock server/clients in the host machine
(some defaults can be implemented in QEMU as well, for example, sending a reply
to the heartbeat) which will rid them of the cumbersome way of running another
whole VM with CID 3. This way, users of nitro-enclave machine in QEMU, could
potentially also run multiple enclaves with their messages for CID 3 forwarded
to different CIDs which, in QEMU side, could then be specified using a new
machine type option (parent-cid) if implemented. I guess in the QEMU side, this
will be an ioctl call (or some other way) to indicate to the host kernel that
the CID 3 messages need to be forwarded. Does this approach of
forwarding CID 3 messages to another CID sound good?

If this approach sounds good, I need some guidance on where the code
should be written in order to achieve this. I would greatly appreciate
any suggestions.

Thanks.

Regards,
Dorjoy

[1] https://docs.aws.amazon.com/enclaves/latest/user/nitro-enclave.html
[2] https://mail.gnu.org/archive/html/qemu-devel/2024-05/msg03524.html
[3] https://aws.amazon.com/ec2/

