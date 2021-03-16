Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAFF033D593
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 15:14:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236082AbhCPONw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 10:13:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:48249 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236065AbhCPONJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Mar 2021 10:13:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615903988;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UVZRtGu3aya80mlgXmhEPVVT/m0iBxUdaLUrPm/zzcM=;
        b=a+piRzJsDkohhLxUoQk+fzQg6A9X4Um8W+7vUzfsRlmNzatG2RIIdyKtU0eynF4o/2YC3l
        i4BXoe6BF8OLr+oAJNgv9QKvA00JmbBJvQ/G/HTr4VZjLsZ4TQPY1R1etnHz26/8trQarL
        ZB0x3tydSinXiG5T6CGsL5SzMDkzE0M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-492-IaHZMAN0OJG4NKcHPf3gQQ-1; Tue, 16 Mar 2021 10:13:05 -0400
X-MC-Unique: IaHZMAN0OJG4NKcHPf3gQQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3217E802B7A;
        Tue, 16 Mar 2021 14:13:03 +0000 (UTC)
Received: from starship (unknown [10.35.207.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 052245D9D3;
        Tue, 16 Mar 2021 14:12:54 +0000 (UTC)
Message-ID: <4238999574b69e144f4b1bff59968ee6ba317959.camel@redhat.com>
Subject: Re: [PATCH 1/3] scripts/gdb: rework lx-symbols gdb script
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Jan Kiszka <jan.kiszka@siemens.com>, kvm@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        Kieran Bingham <kbingham@kernel.org>,
        Jessica Yu <jeyu@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>
Date:   Tue, 16 Mar 2021 16:12:53 +0200
In-Reply-To: <9dcacf3e-bba5-a062-610e-dcf1b0a261a3@siemens.com>
References: <20210315221020.661693-1-mlevitsk@redhat.com>
         <20210315221020.661693-2-mlevitsk@redhat.com>
         <9dcacf3e-bba5-a062-610e-dcf1b0a261a3@siemens.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-03-16 at 14:38 +0100, Jan Kiszka wrote:
> On 15.03.21 23:10, Maxim Levitsky wrote:
> > Fix several issues that are present in lx-symbols script:
> > 
> > * Track module unloads by placing another software breakpoint at 'free_module'
> >   (force uninline this symbol just in case), and use remove-symbol-file
> >   gdb command to unload the symobls of the module that is unloading.
> > 
> >   That gives the gdb a chance to mark all software breakpoints from
> >   this module as pending again.
> >   Also remove the module from the 'known' module list once it is unloaded.
> > 
> > * Since we now track module unload, we don't need to reload all
> >   symbols anymore when 'known' module loaded again (that can't happen anymore).
> >   This allows reloading a module in the debugged kernel to finish much faster,
> >   while lx-symbols tracks module loads and unloads.
> > 
> > * Disable/enable all gdb breakpoints on both module load and unload breakpoint
> >   hits, and not only in 'load_all_symbols' as was done before.
> >   (load_all_symbols is no longer called on breakpoint hit)
> >   That allows gdb to avoid getting confused about the state of the (now two)
> >   internal breakpoints we place.
> > 
> >   Otherwise it will leave them in the kernel code segment, when continuing
> >   which triggers a guest kernel panic as soon as it skips over the 'int3'
> >   instruction and executes the garbage tail of the optcode on which
> >   the breakpoint was placed.
> > 
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> >  kernel/module.c              |   8 ++-
> >  scripts/gdb/linux/symbols.py | 106 +++++++++++++++++++++++++----------
> >  2 files changed, 83 insertions(+), 31 deletions(-)
> > 
> > diff --git a/kernel/module.c b/kernel/module.c
> > index 30479355ab850..ea81fc06ea1f5 100644
> > --- a/kernel/module.c
> > +++ b/kernel/module.c
> > @@ -901,8 +901,12 @@ int module_refcount(struct module *mod)
> >  }
> >  EXPORT_SYMBOL(module_refcount);
> >  
> > -/* This exists whether we can unload or not */
> > -static void free_module(struct module *mod);
> > +/* This exists whether we can unload or not
> > + * Keep it uninlined to provide a reliable breakpoint target,
> > + * e.g. for the gdb helper command 'lx-symbols'.
> > + */
> > +
> > +static noinline void free_module(struct module *mod);
> >  
> >  SYSCALL_DEFINE2(delete_module, const char __user *, name_user,
> >  		unsigned int, flags)
> > diff --git a/scripts/gdb/linux/symbols.py b/scripts/gdb/linux/symbols.py
> > index 1be9763cf8bb2..4ce879548a1ae 100644
> > --- a/scripts/gdb/linux/symbols.py
> > +++ b/scripts/gdb/linux/symbols.py
> > @@ -17,6 +17,24 @@ import re
> >  
> >  from linux import modules, utils
> >  
> > +def save_state():
> 
> Naming is a bit too generic. And it's not only saving the state, it's
> also disabling things.
> 
> > +        breakpoints = []
> > +        if hasattr(gdb, 'breakpoints') and not gdb.breakpoints() is None:
> > +            for bp in gdb.breakpoints():
> > +                breakpoints.append({'breakpoint': bp, 'enabled': bp.enabled})
> > +                bp.enabled = False
> > +
> > +        show_pagination = gdb.execute("show pagination", to_string=True)
> > +        pagination = show_pagination.endswith("on.\n")
> > +        gdb.execute("set pagination off")
> > +
> > +        return {"breakpoints":breakpoints, "show_pagination": show_pagination}
> > +
> > +def load_state(state):
> 
> Maybe rather something with "restore", to make naming balanced. Or is
> there a use case where "state" is not coming from the function above?

I didn't put much thought into naming these functions. 
I'll think of something better.

> 
> > +    for breakpoint in state["breakpoints"]:
> > +        breakpoint['breakpoint'].enabled = breakpoint['enabled']
> > +    gdb.execute("set pagination %s" % ("on" if state["show_pagination"] else "off"))
> > +
> >  
> >  if hasattr(gdb, 'Breakpoint'):
> >      class LoadModuleBreakpoint(gdb.Breakpoint):
> > @@ -30,26 +48,38 @@ if hasattr(gdb, 'Breakpoint'):
> >              module_name = module['name'].string()
> >              cmd = self.gdb_command
> >  
> > +            # module already loaded, false alarm
> > +            if module_name in cmd.loaded_modules:
> > +                return False
> 
> Possibly at all, now that we track unloading? Can our state tracking
> become out-of-sync?

Sadly yes and that happens a lot unless kvm is patched to
avoid injecting interrupts on a single step.
 
What is happening is that this breakpoint is hit, then symbols
are loaded which is a relatively slow process, and by the time
the gdb resumes the guest, a timer interrupt is already pending
(kernel local apic timer is running while vcpus are stopped),
which makes the guest kernel take the interrupt (interrupts are
not disabled in these two intercepted functions) and eventually
return to the breakpoint, and trigger its python handler again.

This happens so often that especially with multiple vcpus,
it is possible to enter live-lock like state where guest+gdb
are stuck in this loop forever.
 
When KVM is patched, that indeed shouldn't happen but the check
won't hurt here.
 
Plus due to the feedback I received on the patch 2, I will end up
implementing the 'don't inject interrupts on single step' as
a new KVM debug feature flag, thus you will need a newer qemu
to make use of it.

> 
> > +
> >              # enforce update if object file is not found
> >              cmd.module_files_updated = False
> >  
> >              # Disable pagination while reporting symbol (re-)loading.
> >              # The console input is blocked in this context so that we would
> >              # get stuck waiting for the user to acknowledge paged output.
> > -            show_pagination = gdb.execute("show pagination", to_string=True)
> > -            pagination = show_pagination.endswith("on.\n")
> > -            gdb.execute("set pagination off")
> > +            state = save_state()
> > +            cmd.load_module_symbols(module)
> > +            load_state(state)
> > +            return False
> >  
> > -            if module_name in cmd.loaded_modules:
> > -                gdb.write("refreshing all symbols to reload module "
> > -                          "'{0}'\n".format(module_name))
> > -                cmd.load_all_symbols()
> > -            else:
> > -                cmd.load_module_symbols(module)
> > +    class UnLoadModuleBreakpoint(gdb.Breakpoint):
> > +        def __init__(self, spec, gdb_command):
> > +            super(UnLoadModuleBreakpoint, self).__init__(spec, internal=True)
> > +            self.silent = True
> > +            self.gdb_command = gdb_command
> > +
> > +        def stop(self):
> > +            module = gdb.parse_and_eval("mod")
> > +            module_name = module['name'].string()
> > +            cmd = self.gdb_command
> >  
> > -            # restore pagination state
> > -            gdb.execute("set pagination %s" % ("on" if pagination else "off"))
> > +            if not module_name in cmd.loaded_modules:
> > +                return False
> >  
> 
> Same question as above. For robustness, checking is not bad. But maybe
> it's worth reporting as well.
> 
> > +            state = save_state()
> > +            cmd.unload_module_symbols(module)
> > +            load_state(state)
> >              return False
> >  
> >  
> > @@ -64,8 +94,9 @@ lx-symbols command."""
> >      module_paths = []
> >      module_files = []
> >      module_files_updated = False
> > -    loaded_modules = []
> > -    breakpoint = None
> > +    loaded_modules = {}
> > +    module_load_breakpoint = None
> > +    module_unload_breakpoint = None
> >  
> >      def __init__(self):
> >          super(LxSymbols, self).__init__("lx-symbols", gdb.COMMAND_FILES,
> > @@ -129,21 +160,32 @@ lx-symbols command."""
> >                  filename=module_file,
> >                  addr=module_addr,
> >                  sections=self._section_arguments(module))
> > +
> >              gdb.execute(cmdline, to_string=True)
> > -            if module_name not in self.loaded_modules:
> > -                self.loaded_modules.append(module_name)
> > +            self.loaded_modules[module_name] = {"module_file": module_file,
> > +                                                "module_addr": module_addr}
> >          else:
> >              gdb.write("no module object found for '{0}'\n".format(module_name))
> >  
> > +    def unload_module_symbols(self, module):
> > +        module_name = module['name'].string()
> > +
> > +        module_file = self.loaded_modules[module_name]["module_file"]
> > +        module_addr = self.loaded_modules[module_name]["module_addr"]
> > +
> > +        gdb.write("unloading @{addr}: {filename}\n".format(
> > +            addr=module_addr, filename=module_file))
> > +        cmdline = "remove-symbol-file {filename}".format(
> > +            filename=module_file)
> > +
> > +        gdb.execute(cmdline, to_string=True)
> > +        del self.loaded_modules[module_name]
> > +
> > +
> >      def load_all_symbols(self):
> >          gdb.write("loading vmlinux\n")
> >  
> > -        # Dropping symbols will disable all breakpoints. So save their states
> > -        # and restore them afterward.
> > -        saved_states = []
> > -        if hasattr(gdb, 'breakpoints') and not gdb.breakpoints() is None:
> > -            for bp in gdb.breakpoints():
> > -                saved_states.append({'breakpoint': bp, 'enabled': bp.enabled})
> > +        state = save_state()
> >  
> >          # drop all current symbols and reload vmlinux
> >          orig_vmlinux = 'vmlinux'
> > @@ -153,15 +195,14 @@ lx-symbols command."""
> >          gdb.execute("symbol-file", to_string=True)
> >          gdb.execute("symbol-file {0}".format(orig_vmlinux))
> >  
> > -        self.loaded_modules = []
> > +        self.loaded_modules = {}
> >          module_list = modules.module_list()
> >          if not module_list:
> >              gdb.write("no modules found\n")
> >          else:
> >              [self.load_module_symbols(module) for module in module_list]
> >  
> > -        for saved_state in saved_states:
> > -            saved_state['breakpoint'].enabled = saved_state['enabled']
> > +        load_state(state)
> >  
> >      def invoke(self, arg, from_tty):
> >          self.module_paths = [os.path.expanduser(p) for p in arg.split()]
> > @@ -174,11 +215,18 @@ lx-symbols command."""
> >          self.load_all_symbols()
> >  
> >          if hasattr(gdb, 'Breakpoint'):
> > -            if self.breakpoint is not None:
> > -                self.breakpoint.delete()
> > -                self.breakpoint = None
> > -            self.breakpoint = LoadModuleBreakpoint(
> > -                "kernel/module.c:do_init_module", self)
> > +            if self.module_load_breakpoint is not None:
> > +                self.module_load_breakpoint.delete()
> > +                self.module_load_breakpoint = None
> > +            self.module_load_breakpoint = \
> > +                LoadModuleBreakpoint("kernel/module.c:do_init_module", self)
> > +
> > +            if self.module_unload_breakpoint is not None:
> > +                self.module_unload_breakpoint.delete()
> > +                self.module_unload_breakpoint = None
> > +            self.module_unload_breakpoint = \
> > +                UnLoadModuleBreakpoint("kernel/module.c:free_module", self)
> > +
> >          else:
> >              gdb.write("Note: symbol update on module loading not supported "
> >                        "with this gdb version\n")
> > 
> 
> Good improvement!

Thanks a lot!

Best regards,
	Maxim Levitsky

> 
> Jan
> 


