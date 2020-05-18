Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDE351D7542
	for <lists+kvm@lfdr.de>; Mon, 18 May 2020 12:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726705AbgERKdG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 May 2020 06:33:06 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:33992 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726270AbgERKdG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 May 2020 06:33:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589797984;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fkZd+ATLBaLYev6yToKjV1ATICAP4OZcw+kqfR8rbuw=;
        b=K6W8Z7f28YGkHY36qZ2Pa/64PH+Bsg6dUmSPk0YExsAlBQZ1yOhu3Oqe8NNgvMRntZxILi
        NqX9CYQixFr7bDSgsfdBD5hdKkvzHfiMJ/2tkVR7lJf5Iype8Tie5AEzS376o3WinTsR6M
        QvO3oW84ULmc4j8G7LmwEF3Q2thanPU=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-164-LxUplNLINjaFU9my4-L1VQ-1; Mon, 18 May 2020 06:33:03 -0400
X-MC-Unique: LxUplNLINjaFU9my4-L1VQ-1
Received: by mail-wr1-f69.google.com with SMTP id l12so5476249wrw.9
        for <kvm@vger.kernel.org>; Mon, 18 May 2020 03:33:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fkZd+ATLBaLYev6yToKjV1ATICAP4OZcw+kqfR8rbuw=;
        b=KB+NoOdGbghjVD1I5sCAnzmUjq3XQh1V5m2xFZtL48boZ0YX7hp36x4eQx0nuwloWf
         vV2CTChb3mlv0Uos3mAp6rNxuSswz4ollWX5VENm86KbdH8A/sHocQz6VgDyB543XT05
         NpD3N3QpzeYWIFu4q2+ToKkjKR9w1IPbZL+96LRnI0W8X6EMDR5rw50SpzWFvci4fL5V
         QXdVNgIIhAZbq71+0QpaYTXCTk1YETYGaYj9InZkE6oYuiNHBS+pGa3xhb5cWOhG1rmo
         F9sb5F0xSrsvAQGekIWUXFrVh3RHZ5Knc+o+AKToU1Vf4ZMSJJHWPkrT3cn0rwhYVxqm
         7jRw==
X-Gm-Message-State: AOAM5334YZ19SX8LWwhnlikF1XwRv+t4U9kCpzOs7wv/SPWJsPB6PTga
        0Ahj1x8aSfxoPpQkTSj6bMRNH5F98Y7a9IMb/29J1wqfYrt1k9jjTJ9/g8MptJ5uCQFN+QHKbY1
        ldhMMB3gluuHQ
X-Received: by 2002:adf:e4c2:: with SMTP id v2mr18711369wrm.72.1589797981964;
        Mon, 18 May 2020 03:33:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzxaKQWu7YzReGiltWAyRl2hw4+e2C71C62VqLQpl2ItwOW1BspXytcsAQK4cMdA6ayUoHJxw==
X-Received: by 2002:adf:e4c2:: with SMTP id v2mr18711347wrm.72.1589797981753;
        Mon, 18 May 2020 03:33:01 -0700 (PDT)
Received: from [192.168.178.58] ([151.30.90.67])
        by smtp.gmail.com with ESMTPSA id e21sm15457996wme.34.2020.05.18.03.33.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2020 03:33:01 -0700 (PDT)
Subject: Re: [PATCH 4/5] rcuwait: Introduce rcuwait_active()
To:     Davidlohr Bueso <dave@stgolabs.net>, tglx@linutronix.de
Cc:     peterz@infradead.org, maz@kernel.org, bigeasy@linutronix.de,
        rostedt@goodmis.org, torvalds@linux-foundation.org,
        will@kernel.org, joel@joelfernandes.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Davidlohr Bueso <dbueso@suse.de>
References: <20200424054837.5138-1-dave@stgolabs.net>
 <20200424054837.5138-5-dave@stgolabs.net>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <57309494-58bf-a11e-e4ac-e669e6af22f2@redhat.com>
Date:   Mon, 18 May 2020 12:33:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200424054837.5138-5-dave@stgolabs.net>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/04/20 07:48, Davidlohr Bueso wrote:
> +/*
> + * Note: this provides no serialization and, just as with waitqueues,
> + * requires care to estimate as to whether or not the wait is active.
> + */
> +static inline int rcuwait_active(struct rcuwait *w)
> +{
> +	return !!rcu_dereference(w->task);
> +}

This needs to be changed to rcu_access_pointer:


--------------- 8< -----------------
From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH] rcuwait: avoid lockdep splats from rcuwait_active()

rcuwait_active only returns whether w->task is not NULL.  This is 
exactly one of the usecases that are mentioned in the documentation
for rcu_access_pointer() where it is correct to bypass lockdep checks.

This avoids a splat from kvm_vcpu_on_spin().

Reported-by: Wanpeng Li <kernellwp@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/include/linux/rcuwait.h b/include/linux/rcuwait.h
index c1414ce44abc..61c56cca95c4 100644
--- a/include/linux/rcuwait.h
+++ b/include/linux/rcuwait.h
@@ -31,7 +31,7 @@ static inline void rcuwait_init(struct rcuwait *w)
  */
 static inline int rcuwait_active(struct rcuwait *w)
 {
-	return !!rcu_dereference(w->task);
+	return !!rcu_access_pointer(w->task);
 }
 
 extern int rcuwait_wake_up(struct rcuwait *w);


Paolo

