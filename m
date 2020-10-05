Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B00228353D
	for <lists+kvm@lfdr.de>; Mon,  5 Oct 2020 13:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726053AbgJEL7x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Oct 2020 07:59:53 -0400
Received: from goliath.siemens.de ([192.35.17.28]:58281 "EHLO
        goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725891AbgJEL7w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Oct 2020 07:59:52 -0400
X-Greylist: delayed 661 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Oct 2020 07:59:51 EDT
Received: from mail2.sbs.de (mail2.sbs.de [192.129.41.66])
        by goliath.siemens.de (8.15.2/8.15.2) with ESMTPS id 095BmabF008270
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 5 Oct 2020 13:48:36 +0200
Received: from [167.87.39.163] ([167.87.39.163])
        by mail2.sbs.de (8.15.2/8.15.2) with ESMTP id 095BmZ88030021;
        Mon, 5 Oct 2020 13:48:36 +0200
Subject: Re: scripts/gdb: issues when loading modules after lx-symbols
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Kieran Bingham <kbingham@kernel.org>, linux-kernel@vger.kernel.org,
        qemu-devel@nongnu.org, kvm <kvm@vger.kernel.org>
References: <CAGxU2F7+Tf+hJxxadT_Rw01O43RU9RsasJiVLpukbhvo1w++fA@mail.gmail.com>
 <9e247182-2cc3-9fac-e12e-9743ef24ec43@siemens.com>
 <20201005081451.ajtm6rctimrg5frr@steredhat>
 <0b862e95-c2a7-ad00-5f57-8d958e4af20c@siemens.com>
 <20201005092953.zu7pn2lveo3j2w4s@steredhat>
 <1aef313c-e399-0f56-17a7-f73c9a189200@siemens.com>
 <20201005110517.s42jo7mvagpzti6b@steredhat>
From:   Jan Kiszka <jan.kiszka@siemens.com>
Message-ID: <f77ff95a-1c63-3243-af3a-d37aeca1f788@siemens.com>
Date:   Mon, 5 Oct 2020 13:48:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201005110517.s42jo7mvagpzti6b@steredhat>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05.10.20 13:05, Stefano Garzarella wrote:
> On Mon, Oct 05, 2020 at 11:45:41AM +0200, Jan Kiszka wrote:
>> On 05.10.20 11:29, Stefano Garzarella wrote:
>>> On Mon, Oct 05, 2020 at 10:33:30AM +0200, Jan Kiszka wrote:
>>>> On 05.10.20 10:14, Stefano Garzarella wrote:
>>>>> On Sun, Oct 04, 2020 at 08:52:37PM +0200, Jan Kiszka wrote:
>>>>>> On 01.10.20 16:31, Stefano Garzarella wrote:
>>>>>>> Hi,
>>>>>>> I had some issues with gdb scripts and kernel modules in Linux 5.9-rc7.
>>>>>>>
>>>>>>> If the modules are already loaded, and I do 'lx-symbols', all work fine.
>>>>>>> But, if I load a kernel module after 'lx-symbols', I had this issue:
>>>>>>>
>>>>>>> [ 5093.393940] invalid opcode: 0000 [#1] SMP PTI
>>>>>>> [ 5093.395134] CPU: 0 PID: 576 Comm: modprobe Not tainted 5.9.0-rc7-ste-00010-gf0b671d9608d-dirty #2
>>>>>>> [ 5093.397566] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.13.0-2.fc32 04/01/2014
>>>>>>> [ 5093.400761] RIP: 0010:do_init_module+0x1/0x270
>>>>>>> [ 5093.402553] Code: ff ff e9 cf fe ff ff 0f 0b 49 c7 c4 f2 ff ff ff e9 c1 fe ff ff e8 5f b2 65 00 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 cc <1f> 44 00 00 55 ba 10 00 00 00 be c0 0c 00 00 48 89 e5 41 56 41 55
>>>>>>> [ 5093.409505] RSP: 0018:ffffc90000563d18 EFLAGS: 00010246
>>>>>>> [ 5093.412056] RAX: 0000000000000000 RBX: ffffffffc010a0c0 RCX: 0000000000004ee3
>>>>>>> [ 5093.414472] RDX: 0000000000004ee2 RSI: ffffea0001efe188 RDI: ffffffffc010a0c0
>>>>>>> [ 5093.416349] RBP: ffffc90000563e50 R08: 0000000000000000 R09: 0000000000000002
>>>>>>> [ 5093.418044] R10: 0000000000000096 R11: 00000000000008a4 R12: ffff88807a0d1280
>>>>>>> [ 5093.424721] R13: ffffffffc010a110 R14: ffff88807a0d1300 R15: ffffc90000563e70
>>>>>>> [ 5093.427138] FS:  00007f018f632740(0000) GS:ffff88807dc00000(0000) knlGS:0000000000000000
>>>>>>> [ 5093.430037] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>>>>>> [ 5093.432279] CR2: 000055fbe282b239 CR3: 000000007922a006 CR4: 0000000000170ef0
>>>>>>> [ 5093.435096] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>>>>>> [ 5093.436765] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>>>>>>> [ 5093.439689] Call Trace:
>>>>>>> [ 5093.440954]  ? load_module+0x24b6/0x27d0
>>>>>>> [ 5093.443212]  ? __kernel_read+0xd6/0x150
>>>>>>> [ 5093.445140]  __do_sys_finit_module+0xd3/0xf0
>>>>>>> [ 5093.446877]  __x64_sys_finit_module+0x1a/0x20
>>>>>>> [ 5093.449098]  do_syscall_64+0x38/0x50
>>>>>>> [ 5093.450877]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>>>>>> [ 5093.456153] RIP: 0033:0x7f018f75c43d
>>>>>>> [ 5093.457728] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 2b 6a 0c 00 f7 d8 64 89 01 48
>>>>>>> [ 5093.466349] RSP: 002b:00007ffd7f080368 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
>>>>>>> [ 5093.470613] RAX: ffffffffffffffda RBX: 0000557e5c96f9c0 RCX: 00007f018f75c43d
>>>>>>> [ 5093.474747] RDX: 0000000000000000 RSI: 0000557e5c964288 RDI: 0000000000000003
>>>>>>> [ 5093.478049] RBP: 0000000000040000 R08: 0000000000000000 R09: 0000000000000000
>>>>>>> [ 5093.481298] R10: 0000000000000003 R11: 0000000000000246 R12: 0000000000000000
>>>>>>> [ 5093.483725] R13: 0000557e5c964288 R14: 0000557e5c96f950 R15: 0000557e5c9775c0
>>>>>>> [ 5093.485778] Modules linked in: virtio_vdpa(+) vdpa sunrpc kvm_intel kvm irqbypass virtio_blk virtio_rng rng_core [last unloaded: virtio_vdpa]
>>>>>>> [ 5093.488695] ---[ end trace 23712ecebc11f53c ]---
>>>>>>>
>>>>>>> Guest kernel: Linux 5.9-rc7
>>>>>>> gdb: GNU gdb (GDB) Fedora 9.1-6.fc32
>>>>>>> I tried with QEMU 4.2.1 and the latest master branch: same issue.
>>>>>>>
>>>>>>>
>>>>>>> I did some digging, and skipping the gdb 'add-symbol-file' command in symbol.py
>>>>>>> avoid the issue, but of course I don't have the symbols loaded:
>>>>>>>
>>>>>>>     diff --git a/scripts/gdb/linux/symbols.py b/scripts/gdb/linux/symbols.py
>>>>>>>     index 1be9763cf8bb..eadfaa4d4907 100644
>>>>>>>     --- a/scripts/gdb/linux/symbols.py
>>>>>>>     +++ b/scripts/gdb/linux/symbols.py
>>>>>>>     @@ -129,7 +129,7 @@ lx-symbols command."""
>>>>>>>                      filename=module_file,
>>>>>>>                      addr=module_addr,
>>>>>>>                      sections=self._section_arguments(module))
>>>>>>>     -            gdb.execute(cmdline, to_string=True)
>>>>>>>     +            #gdb.execute(cmdline, to_string=True)
>>>>>>>                  if module_name not in self.loaded_modules:
>>>>>>>                      self.loaded_modules.append(module_name)
>>>>>>>              else:
>>>>>>>
>>>>>>> I tried several modules and this happens every time after '(gdb) lx-symbols'.
>>>>>>>
>>>>>>> Do you have any hints?
>>>>>>>
>>>>>> I assume you are debugging a kernel inside QEMU/KVM, right?
>>>>>
>>>>> Right!
>>>>>
>>>>>>                                                             Does it work
>>>>>> without -enable-kvm?
>>>>>
>>>>> Yes, disabling kvm it works.
>>>>>
>>>>
>>>> OK, there it is, still...
>>>> What may also "work" is going down to single core.
>>>
>>> No, I tried with single core and kvm enabled and I have the same issue.
>>>
>>>>
>>>>>>
>>>>>> Debugging guests in KVM mode at least was unstable for a long time. I
>>>>>> avoided setting soft-BPs - which is what the script does for the sake of
>>>>>> tracking modules loading -, falling back to hw-BPs, as I had no time to
>>>>>> debug that further. /Maybe/ that's the issue here.
>>>>>
>>>>> Thanks for the suggestion, I'll try to have a look.
>>>>>
>>>>
>>>> Would be great if this issue could finally be resolved. And then covered
>>>> by the kvm-unit tests. Those still succeed, I think.
>>>
>>> Yeah, I'm a bit busy, but I'll try to find a fix.
>>>
>>> Just an update, I tried to follow your suggestion using hw-BPs, but
>>> unfortunately the gdb python module doesn't provide an easy way to set
>>> them, so I hacked a bit gdb forcing hw-BPs and with this patch applied
>>> to gdb I don't see the issue anymore:
>>>
>>> diff --git a/gdb/python/py-breakpoint.c b/gdb/python/py-breakpoint.c
>>> index 7369c91ad9..df8ec92049 100644
>>> --- a/gdb/python/py-breakpoint.c
>>> +++ b/gdb/python/py-breakpoint.c
>>> @@ -57,7 +57,7 @@ struct pybp_code
>>>  static struct pybp_code pybp_codes[] =
>>>  {
>>>    { "BP_NONE", bp_none},
>>> -  { "BP_BREAKPOINT", bp_breakpoint},
>>> +  { "BP_BREAKPOINT", bp_hardware_breakpoint},
>>>    { "BP_WATCHPOINT", bp_watchpoint},
>>>    { "BP_HARDWARE_WATCHPOINT", bp_hardware_watchpoint},
>>>    { "BP_READ_WATCHPOINT", bp_read_watchpoint},
>>> @@ -383,7 +383,7 @@ bppy_get_location (PyObject *self, void *closure)
>>>
>>>    BPPY_REQUIRE_VALID (obj);
>>>
>>> -  if (obj->bp->type != bp_breakpoint)
>>> +  if (obj->bp->type != bp_hardware_breakpoint)
>>>      Py_RETURN_NONE;
>>>
>>>    const char *str = event_location_to_string (obj->bp->location.get ());
>>> @@ -730,7 +730,7 @@ bppy_init (PyObject *self, PyObject *args, PyObject *kwargs)
>>>                                     "temporary","source", "function",
>>>                                     "label", "line", "qualified", NULL };
>>>    const char *spec = NULL;
>>> -  enum bptype type = bp_breakpoint;
>>> +  enum bptype type = bp_hardware_breakpoint;
>>>    int access_type = hw_write;
>>>    PyObject *internal = NULL;
>>>    PyObject *temporary = NULL;
>>> @@ -792,7 +792,7 @@ bppy_init (PyObject *self, PyObject *args, PyObject *kwargs)
>>>      {
>>>        switch (type)
>>>         {
>>> -       case bp_breakpoint:
>>> +       case bp_hardware_breakpoint:
>>>           {
>>>             event_location_up location;
>>>             symbol_name_match_type func_name_match_type
>>> @@ -834,7 +834,7 @@ bppy_init (PyObject *self, PyObject *args, PyObject *kwargs)
>>>             create_breakpoint (python_gdbarch,
>>>                                location.get (), NULL, -1, NULL,
>>>                                0,
>>> -                              temporary_bp, bp_breakpoint,
>>> +                              temporary_bp, bp_hardware_breakpoint,
>>>                                0,
>>>                                AUTO_BOOLEAN_TRUE,
>>>                                ops,
>>> @@ -1007,7 +1007,7 @@ gdbpy_breakpoint_created (struct breakpoint *bp)
>>>    if (!user_breakpoint_p (bp) && bppy_pending_object == NULL)
>>>      return;
>>>
>>> -  if (bp->type != bp_breakpoint
>>> +  if (bp->type != bp_hardware_breakpoint
>>>        && bp->type != bp_watchpoint
>>>        && bp->type != bp_hardware_watchpoint
>>>        && bp->type != bp_read_watchpoint
>>>
>>> Of course it is an hack, but it's a starting point :-)
>>>
>>
>> There are two key differences with soft vs. hard BPs:
>>
>>  - guest code modification to inject and remove INT3 (looking at your
>>    panic, this might be the first thing to check)
>>  - different exception vectors and their reflection to or filtering from
>>    the guest
>>
>> Both are similar in that the need to step over the intercepted
>> instruction in order to resume - except that soft BP needs a
>> remove-step-restore-INT3 cycle.
> 
> Thanks for the explanation!
> 
>>
>> You should try debugging that without the lx-symbols script, just by
>> adding soft BPs and watching what happens to the guest, what becomes
>> incorrectly visible to it. Report, and maybe KVM folks can jump in
>> (adding the list).
> 
> It works well. Also using lx-symbols, without loading new modules in the
> guest after it, I can debug the guest kernel with soft-BP.

Even if putting the BP manually at the same location as lx-symbols does?
BTW, that location is sane?

> 
> The issue with soft-BP seems related to 'add-symbol-file' commands;
> if I skip it in the python script, I don't have the panic.

So, it's the pattern of stopping at a soft-BP, reloading symbols,
resuming after the BP?

Jan

-- 
Siemens AG, T RDA IOT
Corporate Competence Center Embedded Linux
