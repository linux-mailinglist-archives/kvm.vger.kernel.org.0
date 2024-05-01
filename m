Return-Path: <kvm+bounces-16297-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 535508B856F
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 07:52:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E75C01F23A04
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 05:52:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2ABF54CE09;
	Wed,  1 May 2024 05:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="V6JEcsp7"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFF374AEC8
	for <kvm@vger.kernel.org>; Wed,  1 May 2024 05:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714542751; cv=none; b=rShZlKBX71CCjXpndbTMJlVlIzPkAS8Tq/OLbymhOtb8zee2hidqnMSpCv5jmyCO6XLkVZ2J1lLunkij08kOwufRDSLQit2hc8ESBNCGhDmL9xG+ZG26uEVzTJBJ8bxvss5SNBsanFlSjthj2HSM4j4AsEuQiDhRoy5A16SdgPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714542751; c=relaxed/simple;
	bh=1nSr9Dg9aeCD6ofDp9t4KN3z2l/uZPlh2laVEmngj3U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dbiu9aU2kDIDXrlY/O3+eO6KvZJ0gcZsCIz3uF300ZDaETc3YiI/HlQVtec+PXzIEiJ+HDCaGVToz8PRVvlKN7z+DCzlPaRQlP5ZOI7KFRaYgob6yPfJU9oDl76UVnbdfCs4TF/C9+A2/RU27UWx1dv/DGZaIKNkRIU1RfVWShU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=V6JEcsp7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714542748;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=20n5h1sY1heSuCVbLnxOhUJlUUXIFUfl98aiHfNTEi0=;
	b=V6JEcsp7e0CV2rdSYc4KpVBYJYRdiO+lUFZoKH2Ksqk1EAKe5EiIUbyFp/1Sq2dfYkJwF0
	RwOOuHY/WHap8IkbZlUuZT8mtoUt4dVZYapihRj32SckQCDvUI16A16Kn0LTvBhxoybI7v
	UtuRtmBOb1bZIGCgrIrRVGMzONpFgxg=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-664-qw5rqSC0P_ePyb1PJ2sZ3Q-1; Wed, 01 May 2024 01:52:25 -0400
X-MC-Unique: qw5rqSC0P_ePyb1PJ2sZ3Q-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-a51fdbd06c8so408465066b.3
        for <kvm@vger.kernel.org>; Tue, 30 Apr 2024 22:52:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714542744; x=1715147544;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=20n5h1sY1heSuCVbLnxOhUJlUUXIFUfl98aiHfNTEi0=;
        b=j8M37FfyC6it4vg3KXsrQdfsp+oYdJAxYwXY1DSjwR7vrfnUPNy0/rJ0zZcZQA5aIo
         HqYdNvlWpmDbQmjc3DK4Db8kLVLYyYszCMn4Voll4a0kq3q82FnDNLlMQxF8wwaMUDBc
         9BQcZpEitwwRpYKEneIFYjopIMvGfWvoWQEf5uwIVP7ctyR2j91Yp5Xuvfk3oIf8bD5d
         f5uzj/A+V+J/W57n2P5uIT4DsDa10Jsranf+vcvKRJV7TFJlitjPhppPoec3AaMRI5W1
         bD7nmLb/xfnmvJ699ZJPKXZCrqnfWDlMZfhlma4tNWGOCsZ+b30af7eyIRGviAgHcEZZ
         gtIg==
X-Forwarded-Encrypted: i=1; AJvYcCVS3aTtzRGOHlkMzVxJlS8ghUFrRnUz4q0DoccgDNmranXsNHZfDjacUkaBKEFiX+FhM6l5M0YQ7aI+hTdwAPo6VVDv
X-Gm-Message-State: AOJu0YzR1Ab89CUcAQejuyvBgKlfpZ4ZA99VAJNUpTHk5u/GDhuXzchJ
	b4dVlB8qPkR73/lFj3RbVht84DLonWQpeOu43zSznMO4qbZEprhlm1qH7gXbbV990ySyhqatiRd
	ytsjWK3ZSr0nPpyCMBBGPoQwiHwvgbFLEK/uPpf/6AgGRapQVtg==
X-Received: by 2002:a17:906:a24e:b0:a58:866a:1e80 with SMTP id bi14-20020a170906a24e00b00a58866a1e80mr991883ejb.36.1714542743894;
        Tue, 30 Apr 2024 22:52:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGBGvs60kCUCPWvX1cwlAhol2+CkeL02isqut8YkmaCVV+Z+zcH4uvAU7Plv220noZVfxO0rg==
X-Received: by 2002:a17:906:a24e:b0:a58:866a:1e80 with SMTP id bi14-20020a170906a24e00b00a58866a1e80mr991871ejb.36.1714542743405;
        Tue, 30 Apr 2024 22:52:23 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc7:346:6a42:bb79:449b:3f0b:a228])
        by smtp.gmail.com with ESMTPSA id ld4-20020a170906f94400b00a5906d14c31sm2821481ejb.64.2024.04.30.22.52.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Apr 2024 22:52:22 -0700 (PDT)
Date: Wed, 1 May 2024 01:52:16 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Mike Christie <michael.christie@oracle.com>
Cc: Hillf Danton <hdanton@sina.com>, Edward Adam Davis <eadavis@qq.com>,
	syzbot+98edc2df894917b3431f@syzkaller.appspotmail.com,
	jasowang@redhat.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	syzkaller-bugs@googlegroups.com, virtualization@lists.linux.dev
Subject: Re: [PATCH next] vhost_task: after freeing vhost_task it should not
 be accessed in vhost_task_fn
Message-ID: <20240501014753-mutt-send-email-mst@kernel.org>
References: <20240501001544.1606-1-hdanton@sina.com>
 <59d61db8-8d3a-44f1-b664-d4649615afc7@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <59d61db8-8d3a-44f1-b664-d4649615afc7@oracle.com>

On Tue, Apr 30, 2024 at 08:01:11PM -0500, Mike Christie wrote:
> On 4/30/24 7:15 PM, Hillf Danton wrote:
> > On Tue, Apr 30, 2024 at 11:23:04AM -0500, Mike Christie wrote:
> >> On 4/30/24 8:05 AM, Edward Adam Davis wrote:
> >>>  static int vhost_task_fn(void *data)
> >>>  {
> >>>  	struct vhost_task *vtsk = data;
> >>> @@ -51,7 +51,7 @@ static int vhost_task_fn(void *data)
> >>>  			schedule();
> >>>  	}
> >>>  
> >>> -	mutex_lock(&vtsk->exit_mutex);
> >>> +	mutex_lock(&exit_mutex);
> >>>  	/*
> >>>  	 * If a vhost_task_stop and SIGKILL race, we can ignore the SIGKILL.
> >>>  	 * When the vhost layer has called vhost_task_stop it's already stopped
> >>> @@ -62,7 +62,7 @@ static int vhost_task_fn(void *data)
> >>>  		vtsk->handle_sigkill(vtsk->data);
> >>>  	}
> >>>  	complete(&vtsk->exited);
> >>> -	mutex_unlock(&vtsk->exit_mutex);
> >>> +	mutex_unlock(&exit_mutex);
> >>>  
> >>
> >> Edward, thanks for the patch. I think though I just needed to swap the
> >> order of the calls above.
> >>
> >> Instead of:
> >>
> >> complete(&vtsk->exited);
> >> mutex_unlock(&vtsk->exit_mutex);
> >>
> >> it should have been:
> >>
> >> mutex_unlock(&vtsk->exit_mutex);
> >> complete(&vtsk->exited);
> > 
> > JFYI Edward did it [1]
> > 
> > [1] https://lore.kernel.org/lkml/tencent_546DA49414E876EEBECF2C78D26D242EE50A@qq.com/
> 
> Thanks.
> 
> I tested the code with that change and it no longer triggers the UAF.

Weird but syzcaller said that yes it triggers.

Compare
000000000000dcc0ca06174e65d4@google.com
which tests the order
	mutex_unlock(&vtsk->exit_mutex);
	complete(&vtsk->exited);
that you like and says it triggers

and
00000000000097bda906175219bc@google.com
which says it does not trigger.

Whatever you do please send it to syzcaller in the original
thread and then when you post please include the syzcaller report.

Given this gets confusing I'm fine with just a fixup patch,
and note in the commit log where I should squash it.


> I've fixed up the original patch that had the bug and am going to
> resubmit the patchset like how Michael requested.
> 


