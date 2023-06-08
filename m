Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D22AE7284B6
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 18:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233538AbjFHQTg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 12:19:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231465AbjFHQTe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 12:19:34 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 254A0193
        for <kvm@vger.kernel.org>; Thu,  8 Jun 2023 09:19:33 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id 5b1f17b1804b1-3f732d37d7bso5824795e9.0
        for <kvm@vger.kernel.org>; Thu, 08 Jun 2023 09:19:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686241171; x=1688833171;
        h=content-transfer-encoding:mime-version:message-id:date:reply-to
         :user-agent:references:in-reply-to:subject:cc:to:from:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LwKUa8ldcngen6GFhrQGPs6NKhjNvVO+0IjnDh0+dEg=;
        b=mV2eb4QebznzdXRTfSzI4mPrQEtLf8gVIPxQXUG067rrb2dVARQIZBxwl23g6jNAhm
         A33vpQ/OfXnm3neQUSO1FdVXcw9hr6leZYjPLVgALH7vsfp09cQMM2+TrTf6tVHbxh33
         K8QbkaA9pLo6O+EKzzsTkp6IHjBHDiosyWogNIt9XaVHyVpM8FjndK0bhC7ELd0yFYUW
         BHnFZYpylBnI4gk2TSOaJOPdeFmQsNYnNBYE1ZTRVHJDfFpbJQXM9arvRwuZIF1yv6K4
         VXchAtohrWRNTESO5NzyZiUo3fI7m+3ffHrm7gT44jUb4VNht4Pss7YhWxn9OInqgTKR
         FWuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686241171; x=1688833171;
        h=content-transfer-encoding:mime-version:message-id:date:reply-to
         :user-agent:references:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LwKUa8ldcngen6GFhrQGPs6NKhjNvVO+0IjnDh0+dEg=;
        b=hZz4blyk7tpRMUksG/vugsSpX6q37QmRNvvVvjGcAzMnwyKeUIo3YiklXycsaVG1pr
         8Ot0NQwEjXr9LSeE5J+cxjWrcQnTeXJHfnQ0EFVhyg+ovyGnLEUJfPBqyYsaClwqW1yu
         uOOJOPdjZT/RrFdMcKkb68lCp5xreaEGuXXZA6p/9xXx+kgqA3mKE0864zs+U0UcuHnQ
         ke5uPHClvOriUVjqF9goVmtgFYY6uP+QAcF8Ah02jxcy7iqs+R2gq9Yrb8ketmXKhIpd
         OqPsIQWyTuMnZGFFtNo7+6PbVpTOC4DnG7LsTHD5V3IL1Yw87swpGC/iYILD3bCzeEWP
         INIQ==
X-Gm-Message-State: AC+VfDxjorSu6R706BHSgcw0XtsHhbOCoUJWlp39FzcyWDaHrYZXX9U2
        Gwu4Us0y0rJtHRuh5sSRKo8=
X-Google-Smtp-Source: ACHHUZ4hBlwqvctG0hExxD75HdW9a7pGh9GgL5+7XoQjO0fqFANjfyUlIJpXYnEIRqN9Gdc6N7Xh4w==
X-Received: by 2002:a7b:ce92:0:b0:3f6:683:628b with SMTP id q18-20020a7bce92000000b003f60683628bmr1905349wmj.3.1686241171203;
        Thu, 08 Jun 2023 09:19:31 -0700 (PDT)
Received: from gmail.com ([47.60.45.125])
        by smtp.gmail.com with ESMTPSA id n6-20020a7bcbc6000000b003f6f6a6e769sm73800wmi.17.2023.06.08.09.19.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jun 2023 09:19:30 -0700 (PDT)
From:   Juan Quintela <juan.quintela@gmail.com>
To:     Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Cc:     afaerber@suse.de, ale@rev.ng, anjo@rev.ng, bazulay@redhat.com,
        bbauman@redhat.com, chao.p.peng@linux.intel.com, cjia@nvidia.com,
        cw@f00f.org, david.edmondson@oracle.com,
        dustin.kirkland@canonical.com, eblake@redhat.com,
        edgar.iglesias@gmail.com, elena.ufimtseva@oracle.com,
        eric.auger@redhat.com, f4bug@amsat.org,
        Felipe Franciosi <felipe.franciosi@nutanix.com>,
        "iggy@theiggy.com" <iggy@kws1.com>, Warner Losh <wlosh@bsdimp.com>,
        jan.kiszka@web.de, jgg@nvidia.com, jidong.xiao@gmail.com,
        jjherne@linux.vnet.ibm.com, joao.m.martins@oracle.com,
        konrad.wilk@oracle.com, kvm@vger.kernel.org,
        mburton@qti.qualcomm.com, mdean@redhat.com,
        mimu@linux.vnet.ibm.com, peter.maydell@linaro.org,
        qemu-devel@nongnu.org, richard.henderson@linaro.org,
        shameerali.kolothum.thodi@huawei.com, stefanha@gmail.com,
        wei.w.wang@intel.com, z.huo@139.com, zwu.kernel@gmail.com
Subject: Re: QEMU developers fortnightly conference call for 2023-06-13
In-Reply-To: <673a858e-8437-24e0-1ca5-3a2f956bb42c@linaro.org> ("Philippe
        =?utf-8?Q?Mathieu-Daud=C3=A9=22's?= message of "Wed, 7 Jun 2023 17:17:14
 +0200")
References: <calendar-123b3e98-a357-4d85-ac0b-ecce92087a35@google.com>
        <673a858e-8437-24e0-1ca5-3a2f956bb42c@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
Reply-To: juan.quintela@gmail.com
Date:   Thu, 08 Jun 2023 18:19:28 +0200
Message-ID: <87sfb2apv3.fsf@secure.mitica>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FSL_HELO_FAKE,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org> wrote:
> Hi Juan,
>
> On 7/6/23 15:55, juan.quintela@gmail.com wrote:
>> QEMU developers fortnightly conference call
>> Hi
>> Here is the wiki for whover that wants to add topics to the agenda.
>> https://wiki.qemu.org/QEMUCall#Call_for_agenda_for_2023-06-13
>> <https://wiki.qemu.org/QEMUCall#Call_for_agenda_for_2023-06-13>
>> We already have a topic that is "Live Update", so please join.
>> Later, Juan.
>
> KVM Forum 2023 is on Wed 14 and Thu 15, so we can expect people
> interested to assist being traveling on Tue 13.

OK, I am moving this to next week.  Being in a call without people
involved is not going to be good.

> There will be Birds of a Feather sessions on Wed 14 from 15:45
> to 17:45 (Europe/Prague), perhaps this is a better replacement
> (assuming someone from each session volunteer to stream for
> remote audience).

I am not assisting to KVM Forum, but it there is a meeting that I can
join online I will do.

Better if anyone on KVM Forum organize this.

Thanks, Juan.
