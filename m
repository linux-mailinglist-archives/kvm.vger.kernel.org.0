Return-Path: <kvm+bounces-16359-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F68C8B8DDB
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 18:15:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 90B9A1C214CD
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 16:15:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A2CE12FF70;
	Wed,  1 May 2024 16:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JAnz8Xrd"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3289C12FB3E
	for <kvm@vger.kernel.org>; Wed,  1 May 2024 16:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714580114; cv=none; b=C94pZOEU42CVe70GOnEK+KFU2S1fmt+OiKANX4iXSjDtYQ1wtuYVNFEEy8gUWFQgFZXIJZnQLrIQF0kHwqsot6FF3IY2JkdnNNYp8DmEBVQogXeg7tAKPlE0NwhLeLKeWdzjfpE9dmgm9AjCpHEzIPKliKu5b1pWH3vlqRG31H0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714580114; c=relaxed/simple;
	bh=4JZobKXvCAkKEuBLtHUYjgoYsuv0NHezNKIZozxI+3s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MZ2064yln1PWq7KIkcv1S2RadCtjuagwIYzB7keJ5BeW7CmujpspcyPTK5GQGmu/F320IWNwBUxjBlItHENVkvLAVIOYpdd3+xXQMiBuep6amRC9sXml2q7vn5eo+swFm36wUfDRXc6oFy6HdDU3lRQIhgVaJm2KrJLsTokxSdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JAnz8Xrd; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714580111;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=E7mWrcXve95zg3d/M8fss24W5lX0LbUL9bKvtgV/1yg=;
	b=JAnz8XrdfwcdagwgyPJ2rEN7L4oD5lp9XMLiEDGuhgnUd8uFg1HmNzMf9ZQ9PKlfHTmmyX
	XoXittxcBMf0U8isDpO4yzE8mBmXYzJhdKeioTDvz2+JsX7yIsh+1pXz6iowSbkt4SVRIk
	82sg8fJXHUASgykXg8EDkKwsfLeHSKs=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-184-NIbXI_-AMjmJ0QYUY8CpFA-1; Wed, 01 May 2024 12:15:09 -0400
X-MC-Unique: NIbXI_-AMjmJ0QYUY8CpFA-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-34dc66313b3so523329f8f.2
        for <kvm@vger.kernel.org>; Wed, 01 May 2024 09:15:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714580108; x=1715184908;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E7mWrcXve95zg3d/M8fss24W5lX0LbUL9bKvtgV/1yg=;
        b=Eoq9hHpJVNxx1UOIyVMBpfeACjn668sBtX8CnszrvGW+laR3IcS+7lHC0239RV/KiP
         7BlCPNlDM5WAulPjgvPh1AR4ryomaGrrPOkgTQA2oP/VpwGQapZPDv1GUu5aC0am/o46
         qEEbVBLpuYP+hAqMUh3KnDKUNh5OFuW5EP29AVHvVqBDEv7aBrHU071Y8paARZAkNXKt
         9/5nNLme6fH/u+lG222f9fGS1iEYayd2yGZjpzfwS7FHtmdW78opaxgPH2NodCrWfEdJ
         ioHXlw5hXYSWOCS1xMm4EpMjbApWl8a5uFVOyQ/Ae+SiHe5YoPKy/ZSZcl99xeBPd+pw
         YQcQ==
X-Forwarded-Encrypted: i=1; AJvYcCVNPkeEQ++erLCC57FG2A2aVaduPCm4guYGbEyq8aeuIMuQlfE06j7W0oCoqyhM0baKTlMcbEg6rAGuUgfNjz8LTUE3
X-Gm-Message-State: AOJu0Yxb399yzAt51MC/QMRwdScZ27uOUGDSiRB1MBeBq7IBkjipOMCW
	s8ULMDRZ7EkeDFGlzqG5eeikLjMgWMMKX3Q9Gf0V6BSpkkjUR0EL2r6dgMk38Ap+XKMEAlqzvRZ
	rTRo33V2I58D43SIfKWCVtRTvSHCpZqRtGAY2V5ILrEyA1dqvlg==
X-Received: by 2002:a5d:4528:0:b0:343:751e:8ef7 with SMTP id j8-20020a5d4528000000b00343751e8ef7mr3142430wra.51.1714580108374;
        Wed, 01 May 2024 09:15:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFyKzGL84l2usjgV0H/flDoMX0zRy6ou0wp/1X1uaRyOtrwrWRor6D2o1DQAe7+oMIVOR8snA==
X-Received: by 2002:a5d:4528:0:b0:343:751e:8ef7 with SMTP id j8-20020a5d4528000000b00343751e8ef7mr3142404wra.51.1714580107826;
        Wed, 01 May 2024 09:15:07 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc7:346:6a42:bb79:449b:3f0b:a228])
        by smtp.gmail.com with ESMTPSA id bs21-20020a056000071500b0034ddf05a3e6sm1509266wrb.76.2024.05.01.09.15.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 May 2024 09:15:07 -0700 (PDT)
Date: Wed, 1 May 2024 12:15:03 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Mike Christie <michael.christie@oracle.com>
Cc: Hillf Danton <hdanton@sina.com>, Edward Adam Davis <eadavis@qq.com>,
	syzbot+98edc2df894917b3431f@syzkaller.appspotmail.com,
	jasowang@redhat.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	syzkaller-bugs@googlegroups.com, virtualization@lists.linux.dev
Subject: Re: [PATCH next] vhost_task: after freeing vhost_task it should not
 be accessed in vhost_task_fn
Message-ID: <20240501121411-mutt-send-email-mst@kernel.org>
References: <b959b82a-510f-45c0-9e06-acf526c2f4a1@oracle.com>
 <20240501001544.1606-1-hdanton@sina.com>
 <20240501075057.1670-1-hdanton@sina.com>
 <6971427a-d3ab-41c8-b34b-be84a594e40b@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6971427a-d3ab-41c8-b34b-be84a594e40b@oracle.com>

On Wed, May 01, 2024 at 10:57:38AM -0500, Mike Christie wrote:
> On 5/1/24 2:50 AM, Hillf Danton wrote:
> > On Wed, 1 May 2024 02:01:20 -0400 Michael S. Tsirkin <mst@redhat.com>
> >>
> >> and then it failed testing.
> >>
> > So did my patch [1] but then the reason was spotted [2,3]
> > 
> > [1] https://lore.kernel.org/lkml/20240430110209.4310-1-hdanton@sina.com/
> > [2] https://lore.kernel.org/lkml/20240430225005.4368-1-hdanton@sina.com/
> > [3] https://lore.kernel.org/lkml/000000000000a7f8470617589ff2@google.com/
> 
> Just to make sure I understand the conclusion.
> 
> Edward's patch that just swaps the order of the calls:
> 
> https://lore.kernel.org/lkml/tencent_546DA49414E876EEBECF2C78D26D242EE50A@qq.com/
> 
> fixes the UAF. I tested the same in my setup. However, when you guys tested it
> with sysbot, it also triggered a softirq/RCU warning.
> 
> The softirq/RCU part of the issue is fixed with this commit:
> 
> https://lore.kernel.org/all/20240427102808.29356-1-qiang.zhang1211@gmail.com/
> 
> commit 1dd1eff161bd55968d3d46bc36def62d71fb4785
> Author: Zqiang <qiang.zhang1211@gmail.com>
> Date:   Sat Apr 27 18:28:08 2024 +0800
> 
>     softirq: Fix suspicious RCU usage in __do_softirq()
> 
> The problem was that I was testing with -next master which has that patch.
> It looks like you guys were testing against bb7a2467e6be which didn't have
> the patch, and so that's why you guys still hit the softirq/RCU issue. Later
> when you added that patch to your patch, it worked with syzbot.
> 
> So is it safe to assume that the softirq/RCU patch above will be upstream
> when the vhost changes go in or is there a tag I need to add to my patches?

That patch is upstream now. I rebased and asked syzbot to test
https://lore.kernel.org/lkml/tencent_546DA49414E876EEBECF2C78D26D242EE50A@qq.com/
on top.

If that passes I will squash.


