Return-Path: <kvm+bounces-18609-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DC3A48D7E31
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 11:12:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2BEACB229B3
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 09:12:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56E1680603;
	Mon,  3 Jun 2024 09:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VbMPmjXN"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 279FC80039
	for <kvm@vger.kernel.org>; Mon,  3 Jun 2024 09:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717405908; cv=none; b=chaqS64Vu2+T78XZYyPvwQtWpkrNQpCerzV9UXw98TZ5vqF7nobEZ4m35jPxaUWz+M9vsDAJT/wcaRyMAPPsSt4+n0X+fcV/NpVc6lTeuV6tcfMBgibIhzPT6WZzGn8uiAdvIrEHvdfedR3fF6ilqgroFvuDAwnFg1Vw7mUm/PA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717405908; c=relaxed/simple;
	bh=iqhdoPZSi0ezw/wsBfoIF6Lv7cJhHzrakyFbirUptvE=;
	h=Message-ID:Date:MIME-Version:From:To:Cc:Subject:Content-Type; b=bIBWkzSsdDV5F4BiyNFf9QOqcC1ClfXsKo2AwtW/ON3nebHrQypHgMKJzIJY2nr991VH6jQU74IwSpCSuCYG9Uy5km6mgNq0B594NepKPzFheBfUDi438kLDxYHgPjaNaTQy4hUdinJ9fNiA1IvDiLcd4Fk7YT8fsy+GBHnhpNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VbMPmjXN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717405905;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=HEa4fCo3+xDDH/KNPDQeLi7mZmdPffH8ZHa/2NiaMVg=;
	b=VbMPmjXNKmShaq7Z36Efm6nKQ1Eg1UHPqrVh6/lXlLoacsC7ofYh1qbH8zkqtK57USI026
	Erk3TMIHJ5a95Iid1kDroMNX2oAjGELp22w3zPHPfpJ1X/Fiq1DdQxbtLvLnGoiZbP8DZZ
	l6uchjKPbhiBlqKNGmxLbQwg5hRSFxU=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-52-rwgya8dQMky0wPhKCwx4vg-1; Mon, 03 Jun 2024 05:11:43 -0400
X-MC-Unique: rwgya8dQMky0wPhKCwx4vg-1
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-43fb093d29aso34165921cf.2
        for <kvm@vger.kernel.org>; Mon, 03 Jun 2024 02:11:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717405903; x=1718010703;
        h=content-transfer-encoding:autocrypt:subject:cc:to:from
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HEa4fCo3+xDDH/KNPDQeLi7mZmdPffH8ZHa/2NiaMVg=;
        b=GppPgZVfoU3Mpr7raSFkXS4hxpgXIjNCrH4aajNiWi1Nii2gjWYD4DjrTuN+IppCDm
         Az/5e0/DbRz2rUwrQdKAVj55ISA2GjBm8xL/tT1mpVpJbu7QrkfCvrTCXOMiITZZulVz
         uOnabyI0GLxHw/cntUwwB8/3MEsqG+7Y+L52RGnl9aY/tAJwXHeieqxEcvR9xlfprZBJ
         PLkp3V5CSuiDCk+Pt3gcwMDHBnWPiv+66mmPpyqVgU3yiFfLDrkdIra/OCaLOnW5JfgV
         5sO2MHMeVTRD9rF2BFYzchJLCIZ928nyOA1Y26y/C5sl2VZeNJc0N68S3+P+HHxceJ4H
         31sg==
X-Forwarded-Encrypted: i=1; AJvYcCW8DNF3tUJOtEbtp4msV9LpMgHRS4yGzZwxNZW74WxD7dOb8Xx+woYk59mIPqbscu7ra+d4oaQWDlAXwbHn8ZhYRyq/
X-Gm-Message-State: AOJu0Yz5xRVbsLiw9OclWNxdQHOd6/Gx7CyAKv0DD241jjHYmvqfMDMA
	DgPykjUkBx4znDw2jDuwBLRhQQsX39QSKH1mlmW6+f810ybokLZTznvKDLUcpASwBrST1K0vbXW
	6FeSoPZR0lyP02rqNhgKK2UqUwrjoTUqV31aUp47nOUoCrtuwRw==
X-Received: by 2002:a05:622a:1aa0:b0:43e:404a:890c with SMTP id d75a77b69052e-43ff524560bmr75088271cf.19.1717405903418;
        Mon, 03 Jun 2024 02:11:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFH/qRIyJYBTwlqnOoqxTbgqlCorQ0Brex/RtBtrnC0fZb8F+hfT5IK9vL6ObwzA1CZHgzM5g==
X-Received: by 2002:a05:622a:1aa0:b0:43e:404a:890c with SMTP id d75a77b69052e-43ff524560bmr75088121cf.19.1717405902930;
        Mon, 03 Jun 2024 02:11:42 -0700 (PDT)
Received: from [192.168.0.4] (ip-109-43-176-229.web.vodafone.de. [109.43.176.229])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4400810b022sm18307021cf.93.2024.06.03.02.11.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Jun 2024 02:11:42 -0700 (PDT)
Message-ID: <11311ff6-9214-4ead-91f9-c114b6aaf5c6@redhat.com>
Date: Mon, 3 Jun 2024 11:11:40 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
From: Thomas Huth <thuth@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>, KVM <kvm@vger.kernel.org>
Subject: xave kvm-unit-test sometimes failing in CI
Autocrypt: addr=thuth@redhat.com; keydata=
 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
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


  Hi Paolo!

FYI, looks like the "xsave" kvm-unit-test is sometimes failing in the CI, e.g.:

  https://gitlab.com/thuth/kvm-unit-tests/-/jobs/7000623436
  https://gitlab.com/thuth/kvm-unit-tests/-/jobs/7000705993

When it's failing, it claims to have 17 tests, while when it's working, it 
says that it only ran 15 tests, e.g.:

  https://gitlab.com/thuth/kvm-unit-tests/-/jobs/7000775677

... so I assume there is something fishy with the "supported_xcr0 & 
XSTATE_YMM" block in the test?

Any ideas what could be wrong here?

  Thomas


