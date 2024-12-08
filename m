Return-Path: <kvm+bounces-33255-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E0EDB9E8461
	for <lists+kvm@lfdr.de>; Sun,  8 Dec 2024 10:12:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B66D4164BE8
	for <lists+kvm@lfdr.de>; Sun,  8 Dec 2024 09:12:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89AE613AD03;
	Sun,  8 Dec 2024 09:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UReOJmfc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F8BE6F305
	for <kvm@vger.kernel.org>; Sun,  8 Dec 2024 09:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733649136; cv=none; b=ijnyLo4TusdYifAuSahYNFvfXpf9CS48I9nfP0HiseShNWJ236XBdHXYCYGiysml85hQmHxKMmGkz/p3fkjlttbHEwMTWrO+JxAA47lYBXh9zb39nf8g2SmjAgoozJrmK48Q8l7TlF+N4Naawnl5D0r3vkvXxJhP2JitZkeTXcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733649136; c=relaxed/simple;
	bh=okE5BMWvjUusypobUQJm225dyzFux8BltflbWpq6+vQ=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=Lmkbz6aeULi5ad3qnWNoazzy1fUr9k1afXldYgEffTG6f/h71SM8jHAltud56pISShqVmDZVNcC1ffd4aKPsS+0Ac6a+bPXj3IeDXChQc5y8+nsuGau9U9zG/ioLVpEB+Ro8HGmQqK9q8HnBTloH67nrBh9pIfwIanZ7xKs2fNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UReOJmfc; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-7fd20129dceso2888687a12.2
        for <kvm@vger.kernel.org>; Sun, 08 Dec 2024 01:12:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733649134; x=1734253934; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=okE5BMWvjUusypobUQJm225dyzFux8BltflbWpq6+vQ=;
        b=UReOJmfcScr58lC000GrFMVBY+K9UlXxNqNPiYe9h7Rv8zBEvyaqZkHBkeZgrJ9Sha
         y5qQsH3Do4rwerHyQQR1rHrJ4RvtEnBYuvJirwqeNgJX96I3MZCyJO8dOds9qxn+wX3B
         JQ0ba5P55QCTM429orvrm7JQmFviUhTLJlrx5/rQOggY6nPQdE0mbLMKEe0dFEdOv+jf
         08txeR847p/Oe6kaMGUtca3y+ck2xu4FMCoqrlRW8U9OIzbTv5ZCBZrNFx4KL8yFZ7u/
         XPM0rDoY7kC+3VjZ6dhlYrX706hjUOEU0G+QG1AReXsvlzyfJj40/tSaDBA3myNk7bA7
         YpqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733649134; x=1734253934;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=okE5BMWvjUusypobUQJm225dyzFux8BltflbWpq6+vQ=;
        b=QNY3Mfcaw93wGpZeeUJjyT2hCAlUWKee3tqiodvKs+WrkpqwsBwqHnvRfrxpenblfe
         LfmtlfH3AoYulRuGue/p+INfu4k1VZgp7VvWpDF5+ZBHksUAnFufljet652C8AJxNd/d
         0RkHT+/wdvO/t/Q2jtM2TKcDjqkFYs1TXuJ5Cpn0uMTwpig6txvw5INs8uZoRe3y7QQt
         q3zS8WuINu15Uu4WqjiSMP//h24fYLdDJB9ohs0iV62ulQLqMiY9xuvuIIelBgI/uOri
         JGL1j/HY9qX/IhZbmaaiyXhFd+b1eQABso2Sw6UrXFxbuEiyTajqpNSHAfjj8cDPuHna
         mL/A==
X-Gm-Message-State: AOJu0Yzk3hM4XNGrpbmgmymx9MJp4kWzVbkYSZgxuAO865Ola1Mrp4+/
	fXdOWNLHKHdUlNowDr5WzpQIIgGYSc7+hxx4Dv43Z0N3LzouMyLtYo31pubflhTi1dd5fTP0zFq
	6DItd/W0uzuH2Dil17jX9sKLkjormc4Q7pAA=
X-Gm-Gg: ASbGncuhJsPsQ2mtTRouRr0czzxek8jgr48cEpV/IzZKdUUp2Q9k6hEKVgOGnHABE6B
	ZHAi43zNDEAl9BeQeHSd05Ea/sp4phg0RKUg8
X-Google-Smtp-Source: AGHT+IFgr/ro8rv11hqTTuMIkNC/tAAkbQ7lDTNcLUxGe88Fx/QY4WDALDO5Lrfy7n977t4K1lJ17HSNCtjvxhvUTYM=
X-Received: by 2002:a17:903:1206:b0:215:385e:921c with SMTP id
 d9443c01a7336-21614de7837mr111621395ad.51.1733649134445; Sun, 08 Dec 2024
 01:12:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: =?UTF-8?B?5p2O56GV?= <shilishuoya@gmail.com>
Date: Sun, 8 Dec 2024 17:12:04 +0800
Message-ID: <CADTb_0PymBCwj8sdTP058FEe1e=WYqwVLFEiH8Rz=0YOL9iWnw@mail.gmail.com>
Subject: i want to learn some recent development process about kvm, not robot
To: kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

subscribe kvm shilisuoya@gmail.com

