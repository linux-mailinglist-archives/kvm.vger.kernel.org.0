Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 571004BDEB9
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 18:47:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355410AbiBUKpB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 05:45:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbiBUKoq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 05:44:46 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 037736E797
        for <kvm@vger.kernel.org>; Mon, 21 Feb 2022 02:05:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645437906;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=a7pC/8c3cMpM8i5986p+h+SJ6tgl0KTE+K3MKLjypsA=;
        b=QDghDm6L4aPi1yZJ7aNQuA8kjPScrrczg0tCu8Zyr+uUJE3YByJ8UW3PlfytVxeDp8I9Dv
        imxZLJAquwRO+9OSQvr69EyD3JzBuwAg4fXIAmJ2XGwhXyJ61GOPkxTZlxLYCSivgAIxR9
        hUMN5znXzxmtPJbSL+TtsHghYpF/ZPo=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-7-NxwON6GnO7-MMaWecse_7w-1; Mon, 21 Feb 2022 05:05:05 -0500
X-MC-Unique: NxwON6GnO7-MMaWecse_7w-1
Received: by mail-wr1-f72.google.com with SMTP id k20-20020adfc714000000b001e305cd1597so7180753wrg.19
        for <kvm@vger.kernel.org>; Mon, 21 Feb 2022 02:05:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=a7pC/8c3cMpM8i5986p+h+SJ6tgl0KTE+K3MKLjypsA=;
        b=tu4gLQYlsOWAULRjrK4GGzdYaSFjfncoArhdCzlDkouPGTwBPv/kZ9QYkuA7kRvdRI
         07q3AxGAHQrPUD3D/Yz6EquuJH6/70D19LVju4Fh5/Lq/DBM08jJt6Jym8BDtiRNiaje
         y0ANVh5T+jL7/0YjqbjOP2UEVZtZ4isIDo3DJ+k23Altz7hMLSg6SZh5D0faQiWwKASi
         ng1VTGdCNa9OHakY2K0WRLSNTQKmQ9XzCFSZMj6VzIX2GVYVIz+DUCqfOMh+BwDCibrO
         Jn/sB1Yw2gJudopCnKpKRFg4UttLwZarsqcBGSkTOXZ3e0e5nGMVDFivNa8Kw9qFgzwx
         aNIg==
X-Gm-Message-State: AOAM531UYPy7QIygeJH5ZYOJBIHVCcitFxn1aQOb0Z83KJY5IiIj2bMA
        BPGG9C5LZ6HsRqhQTFyR3TntHIxDhnnFCvVctSLcH2wQ5v0yZzp3nlxIen+iK8y4ANKBfrj3k2c
        krzFddm7fQHlo
X-Received: by 2002:adf:cf12:0:b0:1e3:25ac:7b25 with SMTP id o18-20020adfcf12000000b001e325ac7b25mr15345139wrj.196.1645437904144;
        Mon, 21 Feb 2022 02:05:04 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwvL0v2ye0HlLbbizXym02UGy3yMeTg2IZU57hEMg6++fpRjZHeoaP1iJDYrJhnJl0FoOTdYg==
X-Received: by 2002:adf:cf12:0:b0:1e3:25ac:7b25 with SMTP id o18-20020adfcf12000000b001e325ac7b25mr15345112wrj.196.1645437903844;
        Mon, 21 Feb 2022 02:05:03 -0800 (PST)
Received: from sgarzare-redhat (host-95-248-229-156.retail.telecomitalia.it. [95.248.229.156])
        by smtp.gmail.com with ESMTPSA id w18sm32300769wrl.62.2022.02.21.02.05.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 02:05:03 -0800 (PST)
Date:   Mon, 21 Feb 2022 11:05:00 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        syzbot <syzbot+1e3ea63db39f2b4440e0@syzkaller.appspotmail.com>,
        kvm <kvm@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        syzkaller-bugs@googlegroups.com,
        linux-kernel <linux-kernel@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        Stefan Hajnoczi <stefanha@redhat.com>
Subject: Re: [syzbot] WARNING in vhost_dev_cleanup (2)
Message-ID: <20220221100500.2x3s2sddqahgdfyt@sgarzare-redhat>
References: <0000000000006f656005d82d24e2@google.com>
 <CACGkMEsyWBBmx3g613tr97nidHd3-avMyO=WRxS8RpcEk7j2=A@mail.gmail.com>
 <20220217023550-mutt-send-email-mst@kernel.org>
 <CACGkMEtuL_4eRYYWd4aQj6rG=cJDQjjr86DWpid3o_N-6xvTWQ@mail.gmail.com>
 <20220217024359-mutt-send-email-mst@kernel.org>
 <CAGxU2F7CjNu5Wxg3k1hQF8A8uRt-wKLjMW6TMjb+UVCF+MHZbw@mail.gmail.com>
 <0b2a5c63-024b-b7a5-e4d1-aa12390bdd38@oracle.com>
 <a5fca5da-c139-b9bb-1929-d7621c06163d@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <a5fca5da-c139-b9bb-1929-d7621c06163d@oracle.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 18, 2022 at 12:23:10PM -0600, Mike Christie wrote:
>On 2/18/22 11:53 AM, Mike Christie wrote:
>> On 2/17/22 3:48 AM, Stefano Garzarella wrote:
>>>
>>> On Thu, Feb 17, 2022 at 8:50 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>>>>
>>>> On Thu, Feb 17, 2022 at 03:39:48PM +0800, Jason Wang wrote:
>>>>> On Thu, Feb 17, 2022 at 3:36 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>>>>>>
>>>>>> On Thu, Feb 17, 2022 at 03:34:13PM +0800, Jason Wang wrote:
>>>>>>> On Thu, Feb 17, 2022 at 10:01 AM syzbot
>>>>>>> <syzbot+1e3ea63db39f2b4440e0@syzkaller.appspotmail.com> wrote:
>>>>>>>>
>>>>>>>> Hello,
>>>>>>>>
>>>>>>>> syzbot found the following issue on:
>>>>>>>>
>>>>>>>> HEAD commit:    c5d9ae265b10 Merge tag 'for-linus' of git://git.kernel.org..
>>>>>>>> git tree:       upstream
>>>>>>>> console output: https://urldefense.com/v3/__https://syzkaller.appspot.com/x/log.txt?x=132e687c700000__;!!ACWV5N9M2RV99hQ!fLqQTyosTBm7FK50IVmo0ozZhsvUEPFCivEHFDGU3GjlAHDWl07UdOa-t9uf9YisMihn$
>>>>>>>> kernel config:  https://urldefense.com/v3/__https://syzkaller.appspot.com/x/.config?x=a78b064590b9f912__;!!ACWV5N9M2RV99hQ!fLqQTyosTBm7FK50IVmo0ozZhsvUEPFCivEHFDGU3GjlAHDWl07UdOa-t9uf9RjOhplp$
>>>>>>>> dashboard link: https://urldefense.com/v3/__https://syzkaller.appspot.com/bug?extid=1e3ea63db39f2b4440e0__;!!ACWV5N9M2RV99hQ!fLqQTyosTBm7FK50IVmo0ozZhsvUEPFCivEHFDGU3GjlAHDWl07UdOa-t9uf9bBf5tv0$
>>>>>>>> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
>>>>>>>>
>>>>>>>> Unfortunately, I don't have any reproducer for this issue yet.
>>>>>>>>
>>>>>>>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>>>>>>>> Reported-by: syzbot+1e3ea63db39f2b4440e0@syzkaller.appspotmail.com
>>>>>>>>
>>>>>>>> WARNING: CPU: 1 PID: 10828 at drivers/vhost/vhost.c:715 vhost_dev_cleanup+0x8b8/0xbc0 drivers/vhost/vhost.c:715
>>>>>>>> Modules linked in:
>>>>>>>> CPU: 0 PID: 10828 Comm: syz-executor.0 Not tainted 5.17.0-rc4-syzkaller-00051-gc5d9ae265b10 #0
>>>>>>>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>>>>>>>> RIP: 0010:vhost_dev_cleanup+0x8b8/0xbc0 drivers/vhost/vhost.c:715
>>>>>>>
>>>>>>> Probably a hint that we are missing a flush.
>>>>>>>
>>>>>>> Looking at vhost_vsock_stop() that is called by vhost_vsock_dev_release():
>>>>>>>
>>>>>>> static int vhost_vsock_stop(struct vhost_vsock *vsock)
>>>>>>> {
>>>>>>> size_t i;
>>>>>>>         int ret;
>>>>>>>
>>>>>>>         mutex_lock(&vsock->dev.mutex);
>>>>>>>
>>>>>>>         ret = vhost_dev_check_owner(&vsock->dev);
>>>>>>>         if (ret)
>>>>>>>                 goto err;
>>>>>>>
>>>>>>> Where it could fail so the device is not actually stopped.
>>>>>>>
>>>>>>> I wonder if this is something related.
>>>>>>>
>>>>>>> Thanks
>>>>>>
>>>>>>
>>>>>> But then if that is not the owner then no work should be running, right?
>>>>>
>>>>> Could it be a buggy user space that passes the fd to another process
>>>>> and changes the owner just before the mutex_lock() above?
>>>>>
>>>>> Thanks
>>>>
>>>> Maybe, but can you be a bit more explicit? what is the set of
>>>> conditions you see that can lead to this?
>>>
>>> I think the issue could be in the vhost_vsock_stop() as Jason mentioned,
>>> but not related to fd passing, but related to the do_exit() function.
>>>
>>> Looking the stack trace, we are in exit_task_work(), that is called
>>> after exit_mm(), so the vhost_dev_check_owner() can fail because
>>> current->mm should be NULL at that point.
>>>
>>> It seems the fput work is queued by fput_many() in a worker queue, and
>>> in some cases (maybe a lot of files opened?) the work is still queued
>>> when we enter in do_exit().
>> It normally happens if userspace doesn't do a close() when the VM
>
>Just one clarification. I meant to say it "always" happens when userspace
>doesn't do a close.
>
>It doesn't have anything to do with lots of files or something like that.
>We are actually running the vhost device's release function from
>do_exit->task_work_run and so all those __fputs are done from something
>like qemu's context (current == that process).
>
>We are *not* hitting the case:
>
>do_exit->exit_files->put_files_struct->filp_close->fput->fput_many
>
>and then in there hitting the schedule_delayed_work path. For that
>the last __fput would be done from a workqueue thread and so the current
>pointer would point to a completely different thread.
>
>
>
>> is shutdown and instead let's the kernel's reaper code cleanup. The qemu
>> vhost-scsi code doesn't do a close() during shutdown and so this is our
>> normal code path. It also happens when something like qemu is not
>> gracefully shutdown like during a crash.
>>
>> So fire up qemu, start IO, then crash it or kill 9 it while IO is still
>> running and you can hit it.

Thank you very much for this detailed explanation!

>>
>>>
>>> That said, I don't know if we can simply remove that check in
>>> vhost_vsock_stop(), or check if current->mm is NULL, to understand if
>>> the process is exiting.
>>>
>>
>> Should the caller do the vhost_dev_check_owner or tell vhost_vsock_stop
>> when to check?
>>
>> - vhost_vsock_dev_ioctl always wants to check for ownership right?
>>
>> - For vhost_vsock_dev_release ownership doesn't matter because we
>> always want to clean up or it doesn't hurt too much.
>>
>> For the case where we just do open then close and no ioctls then
>> running vhost_vq_set_backend in vhost_vsock_stop is just a minor
>> hit of extra work. If we've done ioctls, but are now in
>> vhost_vsock_dev_release then we know for the graceful and ungraceful
>> case that nothing is going to be accessing this device in the future
>> and it's getting completely freed so we must completely clean it up.

Yep, I think the easiest way is to add a parameter to vhost_vsock_stop() 
to tell when to call vhost_dev_check_owner() or not.  This is because 
dev->mm is protected by dev->mutex, acquired in vhost_vsock_stop().

I will send a patch right away, it would be great if you can review.

Thanks,
Stefano

