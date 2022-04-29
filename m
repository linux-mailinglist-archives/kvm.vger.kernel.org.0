Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 070B7514F96
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 17:36:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378543AbiD2PjS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 11:39:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232486AbiD2PjR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 11:39:17 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A431D5EB3
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 08:35:58 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id m23so11033199ljc.0
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 08:35:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6s1nwoJRGgRDD+cc6eVnKDXhc5zKGyzdqBiCfjhgACw=;
        b=QRe3ug7K1fccdkgWK9+JEOfzzP1wXoDKVm5M/ouWALA2QAkiM9sM5mQaCM+wK7D+v3
         vosrmviy1SYp/52eVj7aSP8AN0D8VAU5Okvb4Ww8xgcqiXF9ZElmdP2YOFbhm7XV0qCz
         OrPJDhWWzcWkt5ISnaWJp4UWFQSRujN2mYmOd3ptUuFcjqk7kK0xf02f8kQk/8GxjGYv
         R8dlQH1h9WQLZqOX7d7Vbo/s7c+YzOvhAVSm7esn70hVYOYtl6QPHQW/lR70eu6ztjZD
         pKiaKcokFfvJ242z+zynG0IN4GowpMyhRJWo/gnYQwpL2wc3PwtK2z0FlehP2gRrMqKr
         MO6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6s1nwoJRGgRDD+cc6eVnKDXhc5zKGyzdqBiCfjhgACw=;
        b=qUrw/lHLDzOSnnaSzo+GdVLgqcdHtpwZZ9YLYcSImC152iuuzRXvEvhHTmiyNBPDdQ
         S2pUJuoqGTlLjT4sKvCtzz/wswP7L8Cc0yFcNC4/dLPQL1BR6MSaFzwBlu+57sITdN0Y
         InYO+Lf9did7aiTdVSwe0ArezMxSvZtLG6jsrj2/fdXUqOdfDgUNDiebXiEFqGrH6abb
         npoUqWSxYAljUU9CZPMidT9PLmw4yOntGZ4n0Tg/lAjz8pNMkouylyubb5Bi7WnvcYxE
         nYFRLBsQhRSNPUR8mGN5n/IaBYBc9FtfTHKdRIb5B63HjGKx8OfLoBIaQPFtULvFQLa3
         nelQ==
X-Gm-Message-State: AOAM532b2hLuuu8OYlA3ggFYwI+KEiG9G4//rlu7EWa1C96zDFtg+Bg7
        5VJGSzX0att8hgJ1jhubWWgpWCRKK8soi9dvrP/uSw==
X-Google-Smtp-Source: ABdhPJyN+azZ/dxOkvmmY0WVIZMlkjaocYqwrPftbufCjEDjpdvoZ1xb9ffcGeGw5Jbxb8q7SMK3CoZJfVIG0FB5O0U=
X-Received: by 2002:a05:651c:1508:b0:24f:2fa6:89a4 with SMTP id
 e8-20020a05651c150800b0024f2fa689a4mr6252956ljf.132.1651246556519; Fri, 29
 Apr 2022 08:35:56 -0700 (PDT)
MIME-Version: 1.0
References: <20220407195908.633003-1-pgonda@google.com> <CAFNjLiXC0AdOw5f8Ovu47D==ex7F0=WN_Ocirymz4xL=mWvC5A@mail.gmail.com>
 <CAMkAt6r-Mc_YN-gVHuCpTj4E1EmcvyYpP9jhtHo5HRHnoNJAdA@mail.gmail.com>
 <CAMkAt6r+OMPWCbV_svUyGWa0qMzjj2UEG29G6P7jb6uH6yko2w@mail.gmail.com>
 <62e9ece1-5d71-f803-3f65-2755160cf1d1@redhat.com> <CAMkAt6q6YLBfo2RceduSXTafckEehawhD4K4hUEuB4ZNqe2kKg@mail.gmail.com>
 <4c0edc90-36a1-4f4c-1923-4b20e7bdbb4c@redhat.com> <CAMkAt6oL5qi7z-eh4z7z8WBhpc=Ow6WtcJA5bDi6-aGMnz135A@mail.gmail.com>
 <CAMkAt6rmDrZfN5DbNOTsKFV57PwEnK2zxgBTCbEPeE206+5v5w@mail.gmail.com> <0d282be4-d612-374d-84ba-067994321bab@redhat.com>
In-Reply-To: <0d282be4-d612-374d-84ba-067994321bab@redhat.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Fri, 29 Apr 2022 09:35:45 -0600
Message-ID: <CAMkAt6ragq4OmnX+n628Yd5pn51qFv4qV20upGR6tTvyYw3U5A@mail.gmail.com>
Subject: Re: [PATCH v3] KVM: SEV: Mark nested locking of vcpu->lock
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     John Sperbeck <jsperbeck@google.com>,
        kvm list <kvm@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 28, 2022 at 5:59 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 4/28/22 23:28, Peter Gonda wrote:
> >
> > So when actually trying this out I noticed that we are releasing the
> > current vcpu iterator but really we haven't actually taken that lock
> > yet. So we'd need to maintain a prev_* pointer and release that one.
>
> Not entirely true because all vcpu->mutex.dep_maps will be for the same
> lock.  The dep_map is essentially a fancy string, in this case
> "&vcpu->mutex".
>
> See the definition of mutex_init:
>
> #define mutex_init(mutex)                                              \
> do {                                                                   \
>          static struct lock_class_key __key;                            \
>                                                                         \
>          __mutex_init((mutex), #mutex, &__key);                         \
> } while (0)
>
> and the dep_map field is initialized with
>
>          lockdep_init_map_wait(&lock->dep_map, name, key, 0, LD_WAIT_SLEEP);
>
> (i.e. all vcpu->mutexes share the same name and key because they have a
> single mutex_init-ialization site).  Lockdep is as crude in theory as it
> is effective in practice!
>
> >
> >           bool acquired = false;
> >           kvm_for_each_vcpu(...) {
> >                   if (!acquired) {
> >                      if (mutex_lock_killable_nested(&vcpu->mutex, role)
> >                          goto out_unlock;
> >                      acquired = true;
> >                   } else {
> >                      if (mutex_lock_killable(&vcpu->mutex, role)
> >                          goto out_unlock;
>
> This will cause a lockdep splat because it uses subclass 0.  All the
> *_nested functions is allow you to specify a subclass other than zero.

OK got it. I now have this to lock:

         kvm_for_each_vcpu (i, vcpu, kvm) {
                  if (prev_vcpu != NULL) {
                          mutex_release(&prev_vcpu->mutex.dep_map, _THIS_IP_);
                          prev_vcpu = NULL;
                  }

                  if (mutex_lock_killable_nested(&vcpu->mutex, role))
                          goto out_unlock;
                  prev_vcpu = vcpu;
          }

But I've noticed the unlocking is in the wrong order since we are
using kvm_for_each_vcpu() I think we need a kvm_for_each_vcpu_rev() or
something. Which maybe a bit for work:
https://elixir.bootlin.com/linux/latest/source/lib/xarray.c#L1119.
Then I think we could something like this to unlock:

         bool acquired = true;
          kvm_for_each_vcpu_rev(i, vcpu, kvm) {
                  if (!acquired) {
                          mutex_acquire(&vcpu->mutex.dep_map, 0, role,
_THIS_IP_);
                  }
                  mutex_unlock(&vcpu->mutex);
                  acquired = false;
          }
>
> Paolo
>
> >                   }
> >           }
> >
> > To unlock:
> >
> >           kvm_for_each_vcpu(...) {
> >              mutex_unlock(&vcpu->mutex);
> >           }
> >
> > This way instead of mocking and releasing the lock_dep we just lock
> > the fist vcpu with mutex_lock_killable_nested(). I think this
> > maintains the property you suggested of "coalesces all the mutexes for
> > a vm in a single subclass".  Thoughts?
>
