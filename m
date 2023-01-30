Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40FB1681A33
	for <lists+kvm@lfdr.de>; Mon, 30 Jan 2023 20:19:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238384AbjA3TTG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Jan 2023 14:19:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238358AbjA3TTE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Jan 2023 14:19:04 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D0EA36086
        for <kvm@vger.kernel.org>; Mon, 30 Jan 2023 11:19:03 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id i17-20020a25bc11000000b007b59a5b74aaso13724756ybh.7
        for <kvm@vger.kernel.org>; Mon, 30 Jan 2023 11:19:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Uvg/IYlaH2+obxJYp/Dpbe1pauEU76hg2j6rMBGLJQ0=;
        b=lxVBRGm3N2Pbh2ViS7EwxKDim/NUIVTIg6i5DGRvjgNW9ucAwCpc/KWNGYkSl1fL3i
         8/iNID0c6NZ2eJy5GgQ2SUy6I5JSRiVrVGN81tOuECP+BlKMlBwEo0C4R7FcdGxnyEaZ
         tOyctIga/pideY7t+HJ4Me7r53AeMrHsRIyiFZvpvH9j+I7RMbSyT8KAMzlUlsVRs8TE
         ay5KY9ANtnfA8SBOBi+KnMMdfljgfxbowg5fI6wlfYhDSuYaNS+B5OZ4OycyWamGUIrH
         ek0y5jM0BAZ1rf3aIykPQ+CDOj3NKA5XEI/G/0KC2RZ96KINV5xFCekZACe2CRdM6102
         tuFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Uvg/IYlaH2+obxJYp/Dpbe1pauEU76hg2j6rMBGLJQ0=;
        b=x9lZtvBVm0QGu5gBhbOncDoN2UAf+YNjjYjoSf2eqpKiMB6CxvJ5DMXSZ8QJxQFbhc
         2IVImWC4tHpewYnVoXUgb34NkZ3eduAmlhYfjBJtMVTCdOv/xtjxC2Vr6Wu0cS7t3BBk
         UbdahW1k+Bun+ujywOTNHONsLWeBCHztZEw5CVfik3TzdCH++czMVpdNO7MxaxmL9Xt+
         XDtQNO8YS44OL5G9i1GxAOtADUl9mw2zVZtEY6tfzUkZOYrJeH00jTiMIEaJcqd7W1dv
         KLcKn6fhLn9SxhYYwnF/6rGNriRO8STe/TKCazUtYWP/pS+PORXP5pacPgu5/pMVpeSJ
         8vTA==
X-Gm-Message-State: AFqh2kpriyWCGcCzNyzo2uveR+oBoaYaTk4SBjtRpxU0y2jWrqCAU3+G
        6RN4ntg2n+nnVpP1yBl0U+QgH28+9fC7oSgkbw==
X-Google-Smtp-Source: AMrXdXt+PSbwzShc+GGfsNBaL1kW6c8YRByiJzCMfz1hl+4nOGo0UhTzsbaTmzmbFKIZKpzhPau8UpMbxBw5QIDgwA==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a81:4006:0:b0:46b:c07c:c1d9 with SMTP
 id l6-20020a814006000000b0046bc07cc1d9mr3853301ywn.56.1675106342366; Mon, 30
 Jan 2023 11:19:02 -0800 (PST)
Date:   Mon, 30 Jan 2023 19:19:01 +0000
In-Reply-To: <62580f66-1bbd-1a7f-c1fa-53dbf51577ec@redhat.com> (message from
 Thomas Huth on Thu, 12 Jan 2023 10:38:22 +0100)
Mime-Version: 1.0
Message-ID: <gsnt7cx3ygnu.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [kvm-unit-tests PATCH v2 1/1] arm: Replace MAX_SMP probe loop in
 favor of reading directly
From:   Colton Lewis <coltonlewis@google.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     pbonzini@redhat.com, nrb@linux.ibm.com, andrew.jones@linux.dev,
        imbrenda@linux.ibm.com, marcorr@google.com,
        alexandru.elisei@arm.com, oliver.upton@linux.dev,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thomas Huth <thuth@redhat.com> writes:

> On 11/01/2023 22.54, Colton Lewis wrote:
>> Replace the MAX_SMP probe loop in favor of reading a number directly
>> from the QEMU error message. This is equally safe as the existing code
>> because the error message has had the same format as long as it has
>> existed, since QEMU v2.10. The final number before the end of the
>> error message line indicates the max QEMU supports. A short awk
>> program is used to extract the number, which becomes the new MAX_SMP
>> value.

>> This loop logic is broken for machines with a number of CPUs that
>> isn't a power of two. A machine with 8 CPUs will test with MAX_SMP=8
>> but a machine with 12 CPUs will test with MAX_SMP=6 because 12 >> 2 ==
>> 6. This can, in rare circumstances, lead to different test results
>> depending only on the number of CPUs the machine has.

>> A previous comment explains the loop should only apply to kernels
>> <=v4.3 on arm and suggests deletion when it becomes tiresome to
>> maintian. However, it is always theoretically possible to test on a
>> machine that has more CPUs than QEMU supports, so it makes sense to
>> leave some check in place.

>> Signed-off-by: Colton Lewis <coltonlewis@google.com>
>> ---
>>    scripts/runtime.bash | 16 +++++++---------
>>    1 file changed, 7 insertions(+), 9 deletions(-)

>> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
>> index f8794e9..4377e75 100644
>> --- a/scripts/runtime.bash
>> +++ b/scripts/runtime.bash
>> @@ -188,12 +188,10 @@ function run()
>>    # Probe for MAX_SMP, in case it's less than the number of host cpus.
>>    #
>>    # This probing currently only works for ARM, as x86 bails on another
>> -# error first. Also, this probing isn't necessary for any ARM hosts
>> -# running kernels later than v4.3, i.e. those including ef748917b52
>> -# "arm/arm64: KVM: Remove 'config KVM_ARM_MAX_VCPUS'". So, at some
>> -# point when maintaining the while loop gets too tiresome, we can
>> -# just remove it...
>> -while $RUNTIME_arch_run _NO_FILE_4Uhere_ -smp $MAX_SMP \
>> -		|& grep -qi 'exceeds max CPUs'; do
>> -	MAX_SMP=$((MAX_SMP >> 1))
>> -done
>> +# error first. The awk program takes the last number from the QEMU
>> +# error message, which gives the allowable MAX_SMP.
>> +if $RUNTIME_arch_run _NO_FILE_4Uhere_ -smp $MAX_SMP \
>> +      |& grep -qi 'exceeds max CPUs'; then
>> +	GET_LAST_NUM='/exceeds max CPUs/ {match($0, /[[:digit:]]+)$/); print  
>> substr($0, RSTART, RLENGTH-1)}'
>> +	MAX_SMP=$($RUNTIME_arch_run _NO_FILE_4Uhere_ -smp $MAX_SMP |&  
>> awk "$GET_LAST_NUM")
>> +fi

> Is that string with "exceeds" really still the recent error message of the
> latest QEMU versions? When I'm running

>    qemu-system-aarch64 -machine virt -smp 1024

> I'm getting:

>    qemu-system-aarch64: Invalid SMP CPUs 1024. The max CPUs
>    supported by machine 'virt-8.0' is 512

> ... thus no "exceeds" in here? What do I miss? Maybe it's better to just
> grep for "max CPUs" ?

The full qemu command run by the test is much more complicated. It takes
a different code path and results in different errors, including the
"exceeds" one. All my testing has been done with QEMU v7.0, released
2022.
