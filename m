Return-Path: <kvm+bounces-22055-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F287793905E
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2024 16:12:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2DCE91C215CF
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2024 14:12:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EC7E16D9D7;
	Mon, 22 Jul 2024 14:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cock.li header.i=@cock.li header.b="wNFXM39V"
X-Original-To: kvm@vger.kernel.org
Received: from mail.cock.li (mail.cock.li [37.120.193.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAC7D8F5E
	for <kvm@vger.kernel.org>; Mon, 22 Jul 2024 14:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.120.193.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721657518; cv=none; b=A2e8LtSftJdsyllk26Drckx7PkM6IppfvS5QZQ60O2djATp4aClYixvY65xveQjW/hgEv30OtiXhbVxZ/mYDp4fq+i9df17ngBDQ/9axY34QIuA6g4bpd7sr6qByhTzsfg0ulQJhouSZrAamdZrtyI+QKYHCjh7f+lgROu+P6UU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721657518; c=relaxed/simple;
	bh=i1M8XGGbLmwXL8Jr7ZS2ULdyGUDyFOJ5ruEMLXoNAiA=;
	h=MIME-Version:Content-Type:Date:From:To:Subject:Message-ID; b=TesjLUSxrWMvmrXKi3jBqv8VE6btqYWzGoIvm0vH+Lfp+oaXuO2n4sv+CJHofBugBVxFLIx1juaUFJ2EzFKnXsVnWrruK8gX3kSzld76DJy5ytEBfCAdmockA8tEaYjxcA/uq52Q0ZzaSCC8ntEXFDCWzhVhtBNKUvcCBQWMUR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cock.li; spf=pass smtp.mailfrom=cock.li; dkim=pass (2048-bit key) header.d=cock.li header.i=@cock.li header.b=wNFXM39V; arc=none smtp.client-ip=37.120.193.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cock.li
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cock.li
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=cock.li; s=mail;
	t=1721657502; bh=i1M8XGGbLmwXL8Jr7ZS2ULdyGUDyFOJ5ruEMLXoNAiA=;
	h=Date:From:To:Subject:From;
	b=wNFXM39VP2fdXWJdRFhtydE6R+2fbhEgsm18TOnvLi12+wRcObC05BrECG+Y8Bm6s
	 EZeo0Op92px1nErs5vDTPqASnsWjksry1SjFaQriilRyVl6fOz9mwHBw45ae8fZlkx
	 kUSZQRKN8zDD2BFIPonyC0g886FuJegH2yh+Wyl4HB/mic9LnBEciCozM7K1vAIfFa
	 1ATI/ooFLcHnYNmrPmgdtBfJOARTzROzNRNfeJqq6ZZn5/+FHP9sWm+WhRe7Z7Wu0q
	 ukITXCBSRVyZFU45zhvinH3QGYDoo900kyb6WqWSd7z8lRGbIYa6Ils8nhA58o+MqL
	 0h4VxIzRwevwg==
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Mon, 22 Jul 2024 10:11:33 -0400
From: privacymiscoccasion@cock.li
To: kvm@vger.kernel.org
Subject: [USB Isolation] USB virt drivers access between guests instead of
 host -> guest?
User-Agent: Roundcube Webmail/1.4.15
Message-ID: <23f30de150579d4893a493a6385f69f6@cock.li>
X-Sender: privacymiscoccasion@cock.li

Hi everyone,

I'm coming over from reading about Qubes OS, which uses the Xen 
hypervisor. In Qubes, the way that untrusted devices like USBs are 
handled is that they are pass through to a VM, which then (I presume) 
allows other guests to access them using virtual drivers.

I'm looking for a theoretical explanation on how this would be possible 
with KVM. I am not a developer and thus am having difficulty 
understanding how one would let a guest access virtual drivers 
connecting to hardware devices like USB and PCIe from another guest.

Any help/practical examples of this would be greatly appreciated. This 
seems to be a hard topic to find and so far I haven't come across 
anything like this.

Thanks!

