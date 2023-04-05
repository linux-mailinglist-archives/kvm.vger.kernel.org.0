Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE76D6D8AA8
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 00:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233678AbjDEWc5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 18:32:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233117AbjDEWcn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 18:32:43 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E09DE7EE1
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 15:32:28 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id o9-20020a170902d4c900b001a2bef29d53so6045341plg.7
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 15:32:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680733948;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Gu2QsUrLzhWAeLzNTmiDWMuuwgGUJt5zdF3ZUZTfDtU=;
        b=Ic1+NmDLa5hMPtGVT8+HebQhOzm+kEy+BqEiLEtn+OlCuFrgeenhk8Ei5IhgHP7PFO
         eeER4W3YVU7OjGoXtDaRa2v00Q4mA4BRjRKbY+moqn9fUzpd9J3fOLNMEsAQwxZSmFAN
         zEtXNk6jlku/4N0COH2zXWsx/euB+01q00epSAu0jyzLc2/sltspKE3bB6roHqVjtGqg
         VzMHDk3si+DA6W8KXKy+W0gYsfEYxlU1JEAsppztBzx/e3ztJAFLGXUIzmY9i5iBOdlz
         /2zB9ElbSyQs7GT/ZG774asZvNwjHOtnCVfMMPNi5dyMxANZV96RmdxXXumeB8Gon07o
         jqsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680733948;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Gu2QsUrLzhWAeLzNTmiDWMuuwgGUJt5zdF3ZUZTfDtU=;
        b=saU/twX1v/jmfzXhO9SNGW+i1Re+vLHfecydpNjn/bCFZmjtP8uCouJGD3QBdEaeP6
         AwjKHOUc6o3COjzzZROhqBNZXpCtmaShJy5dOcYCDjKZDkuwyRjqThgvZEGLz+Es97tR
         CWFYuDrBsqSmnfH3EbL4BAtHPEZUTzqgspzafMPa3Mwmm+as0E9r1IOqVWkFfDW8vabP
         u5MjY0KLlVwk7BjwC1QPstL5AMv/Q3ZhYoFertALSj50oqmBqWnHJcOr1zsztgK7Q9zD
         4W9268HRQjcQPmhLBg5U9DGZlEh2Vis1R7ogzkfZEzqtyIqMc8Fph4iSysrki5TESiTe
         OoTw==
X-Gm-Message-State: AAQBX9esq1ccsBO3UvdNYk3kzHJ0K+5Qf+PUoR34IkwBGtJMbD00NgIK
        A4qAMOeWY3oV3M9PN40+GGfeL6MwEp/cft516Q==
X-Google-Smtp-Source: AKy350bu8kP+l7JHrBlhgnLqNucEG6rtKm9issrnydB2heDAMrKaEZaVtTKV56Xmq1ks6MtG/TvZQI0fxIJ6Cse1xA==
X-Received: from ackerleytng-cloudtop.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1f5f])
 (user=ackerleytng job=sendgmr) by 2002:a05:6a00:2313:b0:593:fcfb:208b with
 SMTP id h19-20020a056a00231300b00593fcfb208bmr4149900pfh.3.1680733947764;
 Wed, 05 Apr 2023 15:32:27 -0700 (PDT)
Date:   Wed, 05 Apr 2023 22:32:26 +0000
In-Reply-To: <20230404082507.sbyfahwc4gdupmya@box.shutemov.name> (kirill@shutemov.name)
Mime-Version: 1.0
Message-ID: <diqzfs9e0xl1.fsf@ackerleytng-cloudtop.c.googlers.com>
Subject: Re: [RFC PATCH v3 1/2] mm: restrictedmem: Allow userspace to specify
 mount for memfd_restricted
From:   Ackerley Tng <ackerleytng@google.com>
To:     "Kirill A. Shutemov" <kirill@shutemov.name>
Cc:     kvm@vger.kernel.org, linux-api@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, qemu-devel@nongnu.org, aarcange@redhat.com,
        ak@linux.intel.com, akpm@linux-foundation.org, arnd@arndb.de,
        bfields@fieldses.org, bp@alien8.de, chao.p.peng@linux.intel.com,
        corbet@lwn.net, dave.hansen@intel.com, david@redhat.com,
        ddutile@redhat.com, dhildenb@redhat.com, hpa@zytor.com,
        hughd@google.com, jlayton@kernel.org, jmattson@google.com,
        joro@8bytes.org, jun.nakajima@intel.com,
        kirill.shutemov@linux.intel.com, linmiaohe@huawei.com,
        luto@kernel.org, mail@maciej.szmigiero.name, mhocko@suse.com,
        michael.roth@amd.com, mingo@redhat.com, naoya.horiguchi@nec.com,
        pbonzini@redhat.com, qperret@google.com, rppt@kernel.org,
        seanjc@google.com, shuah@kernel.org, steven.price@arm.com,
        tabba@google.com, tglx@linutronix.de, vannapurve@google.com,
        vbabka@suse.cz, vkuznets@redhat.com, wanpengli@tencent.com,
        wei.w.wang@intel.com, x86@kernel.org, yu.c.zhang@linux.intel.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Thanks for reviewing these patches!

"Kirill A. Shutemov" <kirill@shutemov.name> writes:

> On Fri, Mar 31, 2023 at 11:50:39PM +0000, Ackerley Tng wrote:

>> ...

>> +static int restrictedmem_create_on_user_mount(int mount_fd)
>> +{
>> +	int ret;
>> +	struct fd f;
>> +	struct vfsmount *mnt;
>> +
>> +	f = fdget_raw(mount_fd);
>> +	if (!f.file)
>> +		return -EBADF;
>> +
>> +	ret = -EINVAL;
>> +	if (!is_mount_root(f.file))
>> +		goto out;
>> +
>> +	mnt = f.file->f_path.mnt;
>> +	if (!is_shmem_mount(mnt))
>> +		goto out;
>> +
>> +	ret = file_permission(f.file, MAY_WRITE | MAY_EXEC);

> Why MAY_EXEC?


Christian pointed out that this check does not make sense, I'll be
removing the entire check in the next revision.

>> +	if (ret)
>> +		goto out;
>> +
>> +	ret = mnt_want_write(mnt);
>> +	if (unlikely(ret))
>> +		goto out;
>> +
>> +	ret = restrictedmem_create(mnt);
>> +
>> +	mnt_drop_write(mnt);
>> +out:
>> +	fdput(f);
>> +
>> +	return ret;
>> +}

> We need review from fs folks. Look mostly sensible, but I have no
> experience in fs.

>> +
>> +SYSCALL_DEFINE2(memfd_restricted, unsigned int, flags, int, mount_fd)
>> +{
>> +	if (flags & ~RMFD_USERMNT)
>> +		return -EINVAL;
>> +
>> +	if (flags == RMFD_USERMNT) {
>> +		if (mount_fd < 0)
>> +			return -EINVAL;
>> +
>> +		return restrictedmem_create_on_user_mount(mount_fd);
>> +	} else {
>> +		return restrictedmem_create(NULL);
>> +	}

> Maybe restructure with single restrictedmem_create() call?

> 	struct vfsmount *mnt = NULL;

> 	if (flags == RMFD_USERMNT) {
> 		...
> 		mnt = ...();
> 	}

> 	return restrictedmem_create(mnt);

Will do so in the next revision.

>> +}
>> +
>>   int restrictedmem_bind(struct file *file, pgoff_t start, pgoff_t end,
>>   		       struct restrictedmem_notifier *notifier, bool exclusive)
>>   {
>> --
>> 2.40.0.348.gf938b09366-goog
