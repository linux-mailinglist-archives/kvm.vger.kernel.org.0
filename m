Return-Path: <kvm+bounces-59390-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B1C9DBB2A43
	for <lists+kvm@lfdr.de>; Thu, 02 Oct 2025 08:43:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5E09E19C40C8
	for <lists+kvm@lfdr.de>; Thu,  2 Oct 2025 06:44:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6DEE298994;
	Thu,  2 Oct 2025 06:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=xenosoft.de header.i=@xenosoft.de header.b="Lph8GhWK"
X-Original-To: kvm@vger.kernel.org
Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de [85.215.255.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9508F1339A4
	for <kvm@vger.kernel.org>; Thu,  2 Oct 2025 06:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759387412; cv=pass; b=pviPcMqZYoOoWrE18pkLoUJd9amzKUREKimGe/soc+uEp3vIhIT/er/jT0SxNowdS/OwTvshVViA4R7KRM5KdIxJ26jnNurvSkJeEqVkdZK7SiDpRuFq8NPGnaMlpYhiJj43CkAHsQ3ZRQ6rO59ciayGjzhLVCdmKDRtObhZ4uY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759387412; c=relaxed/simple;
	bh=+WP7iacRL791X1PmqTHG8ZYWMxr801y+NDhQIuCuWio=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Cc:Content-Type; b=uSbCpsgXI3Ho0MP6PBWMLIiaWTpqPwEyuMPYGPencgXFbuwZUVuEMz0I2EJP11u4q+s+e/sRXOi4ROzWVtj7Pc3qy6buKGblwb6PZ7nDPY63GVCmgvZoT4vvnmUgHps6zDdPbCBCBCZA1sNtQJ4/2d5JFcysJcJcZ5ys9fUTpjQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xenosoft.de; spf=none smtp.mailfrom=xenosoft.de; dkim=pass (2048-bit key) header.d=xenosoft.de header.i=@xenosoft.de header.b=Lph8GhWK; arc=pass smtp.client-ip=85.215.255.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xenosoft.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=xenosoft.de
ARC-Seal: i=1; a=rsa-sha256; t=1759387043; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=VDLN02juceYMv7Cmgv7Htd2wG0IwU9Raeq1HOLTsvnwSjPGZMtBniZqSYMMV7irZke
    MxqPdv2QFfBBso9bVoiK4qMqYWPBndsNqzs5oUtMVnqQSikkjoKedasHKhIZP4k55Sh6
    AwKo/+q4FY5mxITOX1U0htP/j3roB0XW9OxVO8kjE06cRyqCBJCylwhrEBurUfhkyw7Z
    Q3thTAQieRmj5VshNRKHHLAWXZgyxT7d95xkjd4gtt5CWah6rG7IvNJ0Es3mudP1XmMM
    0lBN7x9TqLnguOS+OT78bLQudjLKOl+vrQvdfw69VE1KFPtuFE/nsw7Llk9t04KXG8rC
    tiDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1759387043;
    s=strato-dkim-0002; d=strato.com;
    h=Cc:Subject:From:To:Date:Message-ID:Cc:Date:From:Subject:Sender;
    bh=eAw6AzpT5Dfyjz23xQyF8aSCvloexJ85vyRwx6CtPL4=;
    b=ay+/uQRZ3Qrs/BzBHFqPgOlCobv3/ozAmIcTcRa+4f2LEDWdv+5akzbnD/agpcReRZ
    5neSNpMd1v+iuekJg3qSBtCGXhv+jGeMRF7Vm7YXd89ot8SCAhrfI+8JyGAFroOJ70Pl
    KJ5jR+bhIan73kEVOM8+S6XFtnKZRfG/PQ3Fs9K1bnYAW+v++zvGB+Zge18IrnlNnaSo
    qWHmDVhU93aYD5m0IbREUS7q0XXl0+sS4J/WkEuq/KwKUjG8VDEa/0x1w+XwF3Yu/MIS
    LGCx0jmHSE6SfrBwxcOb9B81gjvjvWwaJUlFCCnOjAZ7GNe0d7yQYjGdYN4+zlAI+qRu
    fyLA==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo00
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1759387043;
    s=strato-dkim-0002; d=xenosoft.de;
    h=Cc:Subject:From:To:Date:Message-ID:Cc:Date:From:Subject:Sender;
    bh=eAw6AzpT5Dfyjz23xQyF8aSCvloexJ85vyRwx6CtPL4=;
    b=Lph8GhWKkS8Z7QUtXqv8anE3IAoSGKkgvECsKoW4GY+CctcyBKF6K/Ooy/nRyX+oab
    Cwzlsnpmv3uBIOadq80OjLXPrLJbvZMsAjMKohAEoXQnvU56y/NgkQxDWrG0QdKthLDq
    hAg0yGl1svQez1lLW4x5SGNM6q1XRupJ8MkiZEgkAIvetHgH0NVD6cJSxe269lmjfS7l
    iDjhexfTWH9mIcwDtQff5v7JIjLfRoP/+bvaw4vEQVUogMoo22A+Y5IrVcoKhKnhAq6W
    scL/q4SuxTRqV6p7kTxODl+QwYwi6ixHiLHHWK+eDmYdxY4NuyiXeTEISk5Uv9sAzSIO
    ecVQ==
X-RZG-AUTH: ":L2QefEenb+UdBJSdRCXu93KJ1bmSGnhMdmOod1DhGN0rBVhd9dFr4thIFiqT9BURIC+m6B7g"
Received: from [192.168.178.48]
    by smtp.strato.de (RZmta 53.3.2 DYNA|AUTH)
    with ESMTPSA id e9e0a61926bMgCP
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Thu, 2 Oct 2025 08:37:22 +0200 (CEST)
Message-ID: <cfd779d6-9440-46b2-9ed5-752f1ae6b5d1@xenosoft.de>
Date: Thu, 2 Oct 2025 08:37:22 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: de-DE
To: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, kvm@vger.kernel.org,
 "debian-powerpc@lists.debian.org" <debian-powerpc@lists.debian.org>
From: Christian Zigotzky <chzigotzky@xenosoft.de>
Subject: KVM-PR no longer works when compiled with new GCC compilers
Cc: "R.T.Dickinson" <rtd2@xtra.co.nz>, hypexed@yahoo.com.au,
 mad skateman <madskateman@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

KVM-PR (-enable-kvm) doesn't work anymore on our PA Semi Nemo boards [1] 
if we compiled it with new GCC compilers.
The VM can't boot. There aren't any messages on the serial console of QEMU.

It boots without KVM-PR.

Kernel config with new GCC compiler [2]:

- CONFIG_CC_VERSION_TEXT="powerpc64-suse-linux-gcc (SUSE Linux) 11.5.0"
- CONFIG_TARGET_CPU="power4"
- CONFIG_TUNE_CPU="-mtune=power10"

It works if I compile it with an old GCC compiler [3]:

- CONFIG_CC_VERSION_TEXT="powerpc-linux-gnu-gcc (Ubuntu 
9.4.0-1ubuntu1~20.04.1) 9.4.0"
- CONFIG_TARGET_CPU="power4"
- CONFIG_TUNE_CPU="-mtune=power9"

Mtune changes to power9 automatically if I compiled it with an old GCC 
compiler. If I compile it with a new GCC compiler again it changes 
automatically to mtune=power10.

Is mtune the reason of the KVM-PR issue? I think the issue is the new 
GCC. [4]

Could you please check whether KVM-PR is compatible with new versions of 
GCC compilers?

Thanks in advance,

Christian



[1] https://en.wikipedia.org/wiki/AmigaOne_X1000

[2] 
https://github.com/chzigotzky/kernels/blob/45186997e6f347fd092f9ab629d62d6041426227/configs/x1000_defconfig

[3] 
https://github.com/chzigotzky/kernels/blob/bc7a3e27b3fcdee52a8135435f02cf807a43872a/configs/x1000_defconfig

[4] KVM-PR no longer works on an X1000 if the kernel has been compiled 
with a new GCC: 
https://forum.hyperion-entertainment.com/viewtopic.php?p=57146#p57146

