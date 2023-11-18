Return-Path: <kvm+bounces-1986-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 924807EFEF1
	for <lists+kvm@lfdr.de>; Sat, 18 Nov 2023 11:39:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C2D421C208EE
	for <lists+kvm@lfdr.de>; Sat, 18 Nov 2023 10:39:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAA2210A10;
	Sat, 18 Nov 2023 10:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="OgOH+LU+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3949D75
	for <kvm@vger.kernel.org>; Sat, 18 Nov 2023 02:39:06 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id d9443c01a7336-1ce5e65ba37so10127195ad.1
        for <kvm@vger.kernel.org>; Sat, 18 Nov 2023 02:39:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1700303946; x=1700908746; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zy1KCU9oTgYlIGJ1CmWqV4X6k+RLxXAN+NT2CTiEe4g=;
        b=OgOH+LU+DlnpLwQZuxxGIoOgEifApS1GwUrc/zmItgbKDpwXwQj0hKw2dQ9h8qisGG
         31MHSx4nUFyYfqUOeC/KsC8vt5SgGRLy/I9zO62oysgiepVdv2LUStmtrQ9X/5xhn3uu
         lKBuB2opDvL4jmKeuncrj7+HCzmR4QQNcnAJBWNNXWhg/x9ju08cZTqsCXgxtcZell1t
         QmMgAU2E12RmFuBRC0Wk9Rxi4J/SDQivi2MuNFNb9l1EfpebPy4SaEuk0cONzx78Klwj
         H7XiyXqGdxFW/TcDXpPSu1+n8Vzv+NGVm8jIv+Mx53l3el4WUk41UdohTbLybQherx48
         SklA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700303946; x=1700908746;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zy1KCU9oTgYlIGJ1CmWqV4X6k+RLxXAN+NT2CTiEe4g=;
        b=ikbSARCmMi2rC0kzxgFYw42gxKgTZ60eaT0V04sWNu4jB98/ApvW1jDLZo9LeeURt6
         IdUZoSasqydF9urNMAIRAPZ+zpYJJU0s5KMy2F44MQn5JiVNcvPupRK2V8huyBDIjgxs
         WByNNUUGRVQsgvdapNHL43wFa1+dvLROQ/scB5JVte5Bd2XrB6mGVt5YChUinKiPy+JU
         TCVL9wnqaRfqKnjg3rnL3wW7oFo126dds3ZdTghRlqg5XzXU9VqOnL3WuxRAloXeYuq1
         pRKxtXIO/9K3FsekMRQEbn6CrUS8u3GOL/lmal824oWrfWwojFSomS0wfVfVBWCLSq/h
         Oqjw==
X-Gm-Message-State: AOJu0YydA6pWG3/p4SIIeq5bnQbygRhBQi+PkIZay5whUL/ofbpUuij2
	wf82jDSwkr2F58Ue5o2zk/KYLQ==
X-Google-Smtp-Source: AGHT+IF5N3QYbHRaegOcdKOfyplWUxrNW29H3jMu8vldA9SOfJqtKJgbzZKkkQCNxUUc0PsWDQo6Hw==
X-Received: by 2002:a17:902:e88e:b0:1cc:5aef:f2c3 with SMTP id w14-20020a170902e88e00b001cc5aeff2c3mr11314929plg.22.1700303946093;
        Sat, 18 Nov 2023 02:39:06 -0800 (PST)
Received: from [157.82.205.15] ([157.82.205.15])
        by smtp.gmail.com with ESMTPSA id c11-20020a170902aa4b00b001b896686c78sm2745643plr.66.2023.11.18.02.38.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Nov 2023 02:39:05 -0800 (PST)
Message-ID: <6253fb6b-9a53-484a-9be5-8facd46c051e@daynix.com>
Date: Sat, 18 Nov 2023 19:38:58 +0900
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 1/7] bpf: Introduce BPF_PROG_TYPE_VNET_HASH
Content-Language: en-US
From: Akihiko Odaki <akihiko.odaki@daynix.com>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
 Jason Wang <jasowang@redhat.com>
Cc: Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>,
 Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>,
 Yonghong Song <yonghong.song@linux.dev>,
 John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>,
 Stanislav Fomichev <sdf@google.com>, Hao Luo <haoluo@google.com>,
 Jiri Olsa <jolsa@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Xuan Zhuo
 <xuanzhuo@linux.alibaba.com>, Mykola Lysenko <mykolal@fb.com>,
 Shuah Khan <shuah@kernel.org>, bpf <bpf@vger.kernel.org>,
 "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
 LKML <linux-kernel@vger.kernel.org>,
 Network Development <netdev@vger.kernel.org>, kvm@vger.kernel.org,
 virtualization@lists.linux-foundation.org,
 "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>,
 Yuri Benditovich <yuri.benditovich@daynix.com>,
 Andrew Melnychenko <andrew@daynix.com>
References: <20231015141644.260646-1-akihiko.odaki@daynix.com>
 <20231015141644.260646-2-akihiko.odaki@daynix.com>
 <CAADnVQLfUDmgYng8Cw1hiZOMfWNWLjbn7ZGc4yOEz-XmeFEz5Q@mail.gmail.com>
 <2594bb24-74dc-4785-b46d-e1bffcc3e7ed@daynix.com>
 <CAADnVQ+J+bOtvEfdvgUse_Rr07rM5KOZ5DtAmHDgRmi70W68+g@mail.gmail.com>
 <CACGkMEs22078F7rSLEz6eQabkZZ=kujSONUNMThZz5Gp=YiidQ@mail.gmail.com>
 <CAADnVQLt8NWvP8qGWMPx=12PwWWE69P7aS2dbm=khAJkCnJEoQ@mail.gmail.com>
 <9a4853ad-5ef4-4b15-a49e-9edb5ae4468e@daynix.com>
In-Reply-To: <9a4853ad-5ef4-4b15-a49e-9edb5ae4468e@daynix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2023/10/18 4:19, Akihiko Odaki wrote:
> On 2023/10/18 4:03, Alexei Starovoitov wrote:
>> On Mon, Oct 16, 2023 at 7:38 PM Jason Wang <jasowang@redhat.com> wrote:
>>>
>>> On Tue, Oct 17, 2023 at 7:53 AM Alexei Starovoitov
>>> <alexei.starovoitov@gmail.com> wrote:
>>>>
>>>> On Sun, Oct 15, 2023 at 10:10 AM Akihiko Odaki 
>>>> <akihiko.odaki@daynix.com> wrote:
>>>>>
>>>>> On 2023/10/16 1:07, Alexei Starovoitov wrote:
>>>>>> On Sun, Oct 15, 2023 at 7:17 AM Akihiko Odaki 
>>>>>> <akihiko.odaki@daynix.com> wrote:
>>>>>>>
>>>>>>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>>>>>>> index 0448700890f7..298634556fab 100644
>>>>>>> --- a/include/uapi/linux/bpf.h
>>>>>>> +++ b/include/uapi/linux/bpf.h
>>>>>>> @@ -988,6 +988,7 @@ enum bpf_prog_type {
>>>>>>>           BPF_PROG_TYPE_SK_LOOKUP,
>>>>>>>           BPF_PROG_TYPE_SYSCALL, /* a program that can execute 
>>>>>>> syscalls */
>>>>>>>           BPF_PROG_TYPE_NETFILTER,
>>>>>>> +       BPF_PROG_TYPE_VNET_HASH,
>>>>>>
>>>>>> Sorry, we do not add new stable program types anymore.
>>>>>>
>>>>>>> @@ -6111,6 +6112,10 @@ struct __sk_buff {
>>>>>>>           __u8  tstamp_type;
>>>>>>>           __u32 :24;              /* Padding, future use. */
>>>>>>>           __u64 hwtstamp;
>>>>>>> +
>>>>>>> +       __u32 vnet_hash_value;
>>>>>>> +       __u16 vnet_hash_report;
>>>>>>> +       __u16 vnet_rss_queue;
>>>>>>>    };
>>>>>>
>>>>>> we also do not add anything to uapi __sk_buff.
>>>>>>
>>>>>>> +const struct bpf_verifier_ops vnet_hash_verifier_ops = {
>>>>>>> +       .get_func_proto         = sk_filter_func_proto,
>>>>>>> +       .is_valid_access        = sk_filter_is_valid_access,
>>>>>>> +       .convert_ctx_access     = bpf_convert_ctx_access,
>>>>>>> +       .gen_ld_abs             = bpf_gen_ld_abs,
>>>>>>> +};
>>>>>>
>>>>>> and we don't do ctx rewrites like this either.
>>>>>>
>>>>>> Please see how hid-bpf and cgroup rstat are hooking up bpf
>>>>>> in _unstable_ way.
>>>>>
>>>>> Can you describe what "stable" and "unstable" mean here? I'm new to 
>>>>> BPF
>>>>> and I'm worried if it may mean the interface stability.
>>>>>
>>>>> Let me describe the context. QEMU bundles an eBPF program that is used
>>>>> for the "eBPF steering program" feature of tun. Now I'm proposing to
>>>>> extend the feature to allow to return some values to the userspace and
>>>>> vhost_net. As such, the extension needs to be done in a way that 
>>>>> ensures
>>>>> interface stability.
>>>>
>>>> bpf is not an option then.
>>>> we do not add stable bpf program types or hooks any more.
>>>
>>> Does this mean eBPF could not be used for any new use cases other than
>>> the existing ones?
>>
>> It means that any new use of bpf has to be unstable for the time being.
> 
> Can you elaborate more about making new use unstable "for the time 
> being?" Is it a temporary situation? What is the rationale for that? 
> Such information will help devise a solution that is best for both of 
> the BPF and network subsystems.
> 
> I would also appreciate if you have some documentation or link to 
> relevant discussions on the mailing list. That will avoid having same 
> discussion you may already have done in the past.

Hi,

The discussion has been stuck for a month, but I'd still like to 
continue figuring out the way best for the whole kernel to implement 
this feature. I summarize the current situation and question that needs 
to be answered before push this forward:

The goal of this RFC is to allow to report hash values calculated with 
eBPF steering program. It's essentially just to report 4 bytes from the 
kernel to the userspace.

Unfortunately, however, it is not acceptable for the BPF subsystem 
because the "stable" BPF is completely fixed these days. The 
"unstable/kfunc" BPF is an alternative, but the eBPF program will be 
shipped with a portable userspace program (QEMU)[1] so the lack of 
interface stability is not tolerable.

Another option is to hardcode the algorithm that was conventionally 
implemented with eBPF steering program in the kernel[2]. It is possible 
because the algorithm strictly follows the virtio-net specification[3]. 
However, there are proposals to add different algorithms to the 
specification[4], and hardcoding the algorithm to the kernel will 
require to add more UAPIs and code each time such a specification change 
happens, which is not good for tuntap.

In short, the proposed feature requires to make either of three compromises:

1. Compromise on the BPF side: Relax the "stable" BPF feature freeze 
once and allow eBPF steering program to report 4 more bytes to the kernel.

2. Compromise on the tuntap side: Implement the algorithm to the kernel, 
and abandon the capability to update the algorithm without changing the 
kernel.

IMHO, I think it's better to make a compromise on the BPF side (option 
1). We should minimize the total UAPI changes in the whole kernel, and 
option 1 is much superior in that sense.

Yet I have to note that such a compromise on the BPF side can risk the 
"stable" BPF feature freeze fragile and let other people complain like 
"you allowed to change stable BPF for this, why do you reject [some 
other request to change stable BPF]?" It is bad for BPF maintainers. (I 
can imagine that introducing and maintaining widely different BPF 
interfaces is too much burden.) And, of course, this requires an 
approval from BPF maintainers.

So I'd like to ask you that which of these compromises you think worse. 
Please also tell me if you have another idea.

Regards,
Akihiko Odaki

[1] https://qemu.readthedocs.io/en/v8.1.0/devel/ebpf_rss.html
[2] 
https://lore.kernel.org/all/20231008052101.144422-1-akihiko.odaki@daynix.com/
[3] 
https://docs.oasis-open.org/virtio/virtio/v1.2/csd01/virtio-v1.2-csd01.html#x1-2400003
[4] 
https://lore.kernel.org/all/CACGkMEuBbGKssxNv5AfpaPpWQfk2BHR83rM5AHXN-YVMf2NvpQ@mail.gmail.com/

