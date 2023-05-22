Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F38470B404
	for <lists+kvm@lfdr.de>; Mon, 22 May 2023 06:13:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbjEVENG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 00:13:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjEVEND (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 00:13:03 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E95CB0
        for <kvm@vger.kernel.org>; Sun, 21 May 2023 21:13:00 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id 38308e7fff4ca-2af28a07be9so29861621fa.2
        for <kvm@vger.kernel.org>; Sun, 21 May 2023 21:13:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1684728778; x=1687320778;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XiXiwoMqZ4rU8glWgj6nQ719y4xoyNn9Lkc6Zi6xKIA=;
        b=MrsMbi3D27rg9slDfG/M44gBDl+IuwjfdQlyogpcrMBcWakq/7OqKBfxjqoWH12KBs
         aI8OzR+MJAA2oSurZv7WaR5jr3NYu0vhkXEM9pVW25Q2csBx1bw9rMemgH21UW+TFKxw
         eiqHQz5vkzqTjMz04SdIpG5PJAxbVYKVrgm8fd0BB7S1Im3FeoBQVLKVhLn/jGMolzPh
         vCeh4FQsT0gHkDwuTjwt7rQmrP2d7kxD8Inn809Yox/mIOUzQHlMQyh34PdhotQpZayv
         QSaspvf52SqKefROfbW1RSeIyRRwHfIfQfa8QD+Ia1QBrYEQlSxpq80HB/mSzOMFU9Gw
         CMUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684728779; x=1687320779;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XiXiwoMqZ4rU8glWgj6nQ719y4xoyNn9Lkc6Zi6xKIA=;
        b=TsMY6PPIoLmj9OYcSZ4oNL2LIxAkuoyDfJhzkFk5s5Cch1UGm6tbaW5shPRZYRtNHG
         JW8QUjX0tTlP2UHP5z7zAH1hMVd5zT4sv7VnZNRicclZY/XAodzFaz9zf/10lTr3bDmC
         NvIu5+eHxLW4RYCxBJTpDxxgN9zXJGgAJm1OpsMbt+ZcF7apE6yb0dMfTz95fo3HfkXT
         G7tqcbQ3YNKjp6Yl+YMJBZ4i1nfWDwKNF4m1L4ANK0LOefSv/RX1bUT5R4GnpTiWRaSt
         EZiMg9vqF9GjKgvJdWYNdm1/O5/MYgVojSGUXEwJ7iQZF5aEL+DSMaQQNltKs4z12fGA
         kIfA==
X-Gm-Message-State: AC+VfDxqjLn+9t5y0NzZxSirVQjcbOZ5PCxV8kfpJbHB1ZAGoZMfuo45
        XED6fobkYRbaFT6ng9Iw1/8/djhequlJS92bPBQVtQ==
X-Google-Smtp-Source: ACHHUZ7TtV6wwQC6UwA1Nz7iZzYWeoDQxjn32ElhikeQvwqRs1rVgW/B5uv5t/z5sB8xJNofUHJvHADN4Xhrq9C81PE=
X-Received: by 2002:a2e:9416:0:b0:2ac:8992:272d with SMTP id
 i22-20020a2e9416000000b002ac8992272dmr3227324ljh.11.1684728778615; Sun, 21
 May 2023 21:12:58 -0700 (PDT)
MIME-Version: 1.0
References: <20230518161949.11203-21-andy.chiu@sifive.com> <202305210917.aS7cWlKv-lkp@intel.com>
In-Reply-To: <202305210917.aS7cWlKv-lkp@intel.com>
From:   Andy Chiu <andy.chiu@sifive.com>
Date:   Mon, 22 May 2023 12:12:47 +0800
Message-ID: <CABgGipWqYytkEKrVi0FYQ_y8A30AzaAc2e0hH-TssK-OR_DpBg@mail.gmail.com>
Subject: Re: [PATCH -next v20 20/26] riscv: Add prctl controls for userspace
 vector management
To:     kernel test robot <lkp@intel.com>
Cc:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Vincent Chen <vincent.chen@sifive.com>,
        Guo Ren <guoren@kernel.org>,
        Heiko Stuebner <heiko.stuebner@vrull.eu>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Sunil V L <sunilvl@ventanamicro.com>,
        Jisheng Zhang <jszhang@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Stefan Roesch <shr@devkernel.io>,
        Joey Gouly <joey.gouly@arm.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Jordy Zomer <jordyzomer@google.com>,
        David Hildenbrand <david@redhat.com>,
        Alexey Gladkov <legion@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, May 21, 2023 at 9:51=E2=80=AFAM kernel test robot <lkp@intel.com> w=
rote:
>
> Hi Andy,
>
> kernel test robot noticed the following build errors:
>
> [auto build test ERROR on next-20230518]
>
> url:    https://github.com/intel-lab-lkp/linux/commits/Andy-Chiu/riscv-Re=
name-__switch_to_aux-fpu/20230519-005938
> base:   next-20230518
> patch link:    https://lore.kernel.org/r/20230518161949.11203-21-andy.chi=
u%40sifive.com
> patch subject: [PATCH -next v20 20/26] riscv: Add prctl controls for user=
space vector management
> config: arm-sp7021_defconfig
> compiler: clang version 17.0.0 (https://github.com/llvm/llvm-project b0fb=
98227c90adf2536c9ad644a74d5e92961111)
> reproduce (this is a W=3D1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbi=
n/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # install arm cross compiling tool for clang build
>         # apt-get install binutils-arm-linux-gnueabi
>         # https://github.com/intel-lab-lkp/linux/commit/eef6095228f3323db=
8f2bddd5bde768976888558
>         git remote add linux-review https://github.com/intel-lab-lkp/linu=
x
>         git fetch --no-tags linux-review Andy-Chiu/riscv-Rename-__switch_=
to_aux-fpu/20230519-005938
>         git checkout eef6095228f3323db8f2bddd5bde768976888558
>         # save the config file
>         mkdir build_dir && cp config build_dir/.config
>         COMPILER_INSTALL_PATH=3D$HOME/0day COMPILER=3Dclang make.cross W=
=3D1 O=3Dbuild_dir ARCH=3Darm olddefconfig
>         COMPILER_INSTALL_PATH=3D$HOME/0day COMPILER=3Dclang make.cross W=
=3D1 O=3Dbuild_dir ARCH=3Darm SHELL=3D/bin/bash
>
> If you fix the issue, kindly add following tag where applicable
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202305210917.aS7cWlKv-lkp=
@intel.com/
>
> All errors (new ones prefixed by >>):
>
> >> kernel/sys.c:2718:11: error: call to undeclared function 'RISCV_V_SET_=
CONTROL'; ISO C99 and later do not support implicit function declarations [=
-Wimplicit-function-declaration]
>                    error =3D RISCV_V_SET_CONTROL(arg2);
>                            ^
> >> kernel/sys.c:2721:11: error: call to undeclared function 'RISCV_V_GET_=
CONTROL'; ISO C99 and later do not support implicit function declarations [=
-Wimplicit-function-declaration]
>                    error =3D RISCV_V_GET_CONTROL();
>                            ^
>    2 errors generated.
>
>
> vim +/RISCV_V_SET_CONTROL +2718 kernel/sys.c
>
>   2407
>   2408  SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned=
 long, arg3,
>   2409                  unsigned long, arg4, unsigned long, arg5)
>   2410  {
>   2411          struct task_struct *me =3D current;
>   2412          unsigned char comm[sizeof(me->comm)];
>   2413          long error;
>   2414
>   2415          error =3D security_task_prctl(option, arg2, arg3, arg4, a=
rg5);
>   2416          if (error !=3D -ENOSYS)
>   2417                  return error;
>   2418
>   2419          error =3D 0;
>   2420          switch (option) {
>   2421          case PR_SET_PDEATHSIG:
>   2422                  if (!valid_signal(arg2)) {
>   2423                          error =3D -EINVAL;
>   2424                          break;
>   2425                  }
>   2426                  me->pdeath_signal =3D arg2;
>   2427                  break;
>   2428          case PR_GET_PDEATHSIG:
>   2429                  error =3D put_user(me->pdeath_signal, (int __user=
 *)arg2);
>   2430                  break;
>   2431          case PR_GET_DUMPABLE:
>   2432                  error =3D get_dumpable(me->mm);
>   2433                  break;
>   2434          case PR_SET_DUMPABLE:
>   2435                  if (arg2 !=3D SUID_DUMP_DISABLE && arg2 !=3D SUID=
_DUMP_USER) {
>   2436                          error =3D -EINVAL;
>   2437                          break;
>   2438                  }
>   2439                  set_dumpable(me->mm, arg2);
>   2440                  break;
>   2441
>   2442          case PR_SET_UNALIGN:
>   2443                  error =3D SET_UNALIGN_CTL(me, arg2);
>   2444                  break;
>   2445          case PR_GET_UNALIGN:
>   2446                  error =3D GET_UNALIGN_CTL(me, arg2);
>   2447                  break;
>   2448          case PR_SET_FPEMU:
>   2449                  error =3D SET_FPEMU_CTL(me, arg2);
>   2450                  break;
>   2451          case PR_GET_FPEMU:
>   2452                  error =3D GET_FPEMU_CTL(me, arg2);
>   2453                  break;
>   2454          case PR_SET_FPEXC:
>   2455                  error =3D SET_FPEXC_CTL(me, arg2);
>   2456                  break;
>   2457          case PR_GET_FPEXC:
>   2458                  error =3D GET_FPEXC_CTL(me, arg2);
>   2459                  break;
>   2460          case PR_GET_TIMING:
>   2461                  error =3D PR_TIMING_STATISTICAL;
>   2462                  break;
>   2463          case PR_SET_TIMING:
>   2464                  if (arg2 !=3D PR_TIMING_STATISTICAL)
>   2465                          error =3D -EINVAL;
>   2466                  break;
>   2467          case PR_SET_NAME:
>   2468                  comm[sizeof(me->comm) - 1] =3D 0;
>   2469                  if (strncpy_from_user(comm, (char __user *)arg2,
>   2470                                        sizeof(me->comm) - 1) < 0)
>   2471                          return -EFAULT;
>   2472                  set_task_comm(me, comm);
>   2473                  proc_comm_connector(me);
>   2474                  break;
>   2475          case PR_GET_NAME:
>   2476                  get_task_comm(comm, me);
>   2477                  if (copy_to_user((char __user *)arg2, comm, sizeo=
f(comm)))
>   2478                          return -EFAULT;
>   2479                  break;
>   2480          case PR_GET_ENDIAN:
>   2481                  error =3D GET_ENDIAN(me, arg2);
>   2482                  break;
>   2483          case PR_SET_ENDIAN:
>   2484                  error =3D SET_ENDIAN(me, arg2);
>   2485                  break;
>   2486          case PR_GET_SECCOMP:
>   2487                  error =3D prctl_get_seccomp();
>   2488                  break;
>   2489          case PR_SET_SECCOMP:
>   2490                  error =3D prctl_set_seccomp(arg2, (char __user *)=
arg3);
>   2491                  break;
>   2492          case PR_GET_TSC:
>   2493                  error =3D GET_TSC_CTL(arg2);
>   2494                  break;
>   2495          case PR_SET_TSC:
>   2496                  error =3D SET_TSC_CTL(arg2);
>   2497                  break;
>   2498          case PR_TASK_PERF_EVENTS_DISABLE:
>   2499                  error =3D perf_event_task_disable();
>   2500                  break;
>   2501          case PR_TASK_PERF_EVENTS_ENABLE:
>   2502                  error =3D perf_event_task_enable();
>   2503                  break;
>   2504          case PR_GET_TIMERSLACK:
>   2505                  if (current->timer_slack_ns > ULONG_MAX)
>   2506                          error =3D ULONG_MAX;
>   2507                  else
>   2508                          error =3D current->timer_slack_ns;
>   2509                  break;
>   2510          case PR_SET_TIMERSLACK:
>   2511                  if (arg2 <=3D 0)
>   2512                          current->timer_slack_ns =3D
>   2513                                          current->default_timer_sl=
ack_ns;
>   2514                  else
>   2515                          current->timer_slack_ns =3D arg2;
>   2516                  break;
>   2517          case PR_MCE_KILL:
>   2518                  if (arg4 | arg5)
>   2519                          return -EINVAL;
>   2520                  switch (arg2) {
>   2521                  case PR_MCE_KILL_CLEAR:
>   2522                          if (arg3 !=3D 0)
>   2523                                  return -EINVAL;
>   2524                          current->flags &=3D ~PF_MCE_PROCESS;
>   2525                          break;
>   2526                  case PR_MCE_KILL_SET:
>   2527                          current->flags |=3D PF_MCE_PROCESS;
>   2528                          if (arg3 =3D=3D PR_MCE_KILL_EARLY)
>   2529                                  current->flags |=3D PF_MCE_EARLY;
>   2530                          else if (arg3 =3D=3D PR_MCE_KILL_LATE)
>   2531                                  current->flags &=3D ~PF_MCE_EARLY=
;
>   2532                          else if (arg3 =3D=3D PR_MCE_KILL_DEFAULT)
>   2533                                  current->flags &=3D
>   2534                                                  ~(PF_MCE_EARLY|PF=
_MCE_PROCESS);
>   2535                          else
>   2536                                  return -EINVAL;
>   2537                          break;
>   2538          case PR_GET_AUXV:
>   2539                  if (arg4 || arg5)
>   2540                          return -EINVAL;
>   2541                  error =3D prctl_get_auxv((void __user *)arg2, arg=
3);
>   2542                  break;
>   2543                  default:
>   2544                          return -EINVAL;
>   2545                  }
>   2546                  break;
>   2547          case PR_MCE_KILL_GET:
>   2548                  if (arg2 | arg3 | arg4 | arg5)
>   2549                          return -EINVAL;
>   2550                  if (current->flags & PF_MCE_PROCESS)
>   2551                          error =3D (current->flags & PF_MCE_EARLY)=
 ?
>   2552                                  PR_MCE_KILL_EARLY : PR_MCE_KILL_L=
ATE;
>   2553                  else
>   2554                          error =3D PR_MCE_KILL_DEFAULT;
>   2555                  break;
>   2556          case PR_SET_MM:
>   2557                  error =3D prctl_set_mm(arg2, arg3, arg4, arg5);
>   2558                  break;
>   2559          case PR_GET_TID_ADDRESS:
>   2560                  error =3D prctl_get_tid_address(me, (int __user *=
 __user *)arg2);
>   2561                  break;
>   2562          case PR_SET_CHILD_SUBREAPER:
>   2563                  me->signal->is_child_subreaper =3D !!arg2;
>   2564                  if (!arg2)
>   2565                          break;
>   2566
>   2567                  walk_process_tree(me, propagate_has_child_subreap=
er, NULL);
>   2568                  break;
>   2569          case PR_GET_CHILD_SUBREAPER:
>   2570                  error =3D put_user(me->signal->is_child_subreaper=
,
>   2571                                   (int __user *)arg2);
>   2572                  break;
>   2573          case PR_SET_NO_NEW_PRIVS:
>   2574                  if (arg2 !=3D 1 || arg3 || arg4 || arg5)
>   2575                          return -EINVAL;
>   2576
>   2577                  task_set_no_new_privs(current);
>   2578                  break;
>   2579          case PR_GET_NO_NEW_PRIVS:
>   2580                  if (arg2 || arg3 || arg4 || arg5)
>   2581                          return -EINVAL;
>   2582                  return task_no_new_privs(current) ? 1 : 0;
>   2583          case PR_GET_THP_DISABLE:
>   2584                  if (arg2 || arg3 || arg4 || arg5)
>   2585                          return -EINVAL;
>   2586                  error =3D !!test_bit(MMF_DISABLE_THP, &me->mm->fl=
ags);
>   2587                  break;
>   2588          case PR_SET_THP_DISABLE:
>   2589                  if (arg3 || arg4 || arg5)
>   2590                          return -EINVAL;
>   2591                  if (mmap_write_lock_killable(me->mm))
>   2592                          return -EINTR;
>   2593                  if (arg2)
>   2594                          set_bit(MMF_DISABLE_THP, &me->mm->flags);
>   2595                  else
>   2596                          clear_bit(MMF_DISABLE_THP, &me->mm->flags=
);
>   2597                  mmap_write_unlock(me->mm);
>   2598                  break;
>   2599          case PR_MPX_ENABLE_MANAGEMENT:
>   2600          case PR_MPX_DISABLE_MANAGEMENT:
>   2601                  /* No longer implemented: */
>   2602                  return -EINVAL;
>   2603          case PR_SET_FP_MODE:
>   2604                  error =3D SET_FP_MODE(me, arg2);
>   2605                  break;
>   2606          case PR_GET_FP_MODE:
>   2607                  error =3D GET_FP_MODE(me);
>   2608                  break;
>   2609          case PR_SVE_SET_VL:
>   2610                  error =3D SVE_SET_VL(arg2);
>   2611                  break;
>   2612          case PR_SVE_GET_VL:
>   2613                  error =3D SVE_GET_VL();
>   2614                  break;
>   2615          case PR_SME_SET_VL:
>   2616                  error =3D SME_SET_VL(arg2);
>   2617                  break;
>   2618          case PR_SME_GET_VL:
>   2619                  error =3D SME_GET_VL();
>   2620                  break;
>   2621          case PR_GET_SPECULATION_CTRL:
>   2622                  if (arg3 || arg4 || arg5)
>   2623                          return -EINVAL;
>   2624                  error =3D arch_prctl_spec_ctrl_get(me, arg2);
>   2625                  break;
>   2626          case PR_SET_SPECULATION_CTRL:
>   2627                  if (arg4 || arg5)
>   2628                          return -EINVAL;
>   2629                  error =3D arch_prctl_spec_ctrl_set(me, arg2, arg3=
);
>   2630                  break;
>   2631          case PR_PAC_RESET_KEYS:
>   2632                  if (arg3 || arg4 || arg5)
>   2633                          return -EINVAL;
>   2634                  error =3D PAC_RESET_KEYS(me, arg2);
>   2635                  break;
>   2636          case PR_PAC_SET_ENABLED_KEYS:
>   2637                  if (arg4 || arg5)
>   2638                          return -EINVAL;
>   2639                  error =3D PAC_SET_ENABLED_KEYS(me, arg2, arg3);
>   2640                  break;
>   2641          case PR_PAC_GET_ENABLED_KEYS:
>   2642                  if (arg2 || arg3 || arg4 || arg5)
>   2643                          return -EINVAL;
>   2644                  error =3D PAC_GET_ENABLED_KEYS(me);
>   2645                  break;
>   2646          case PR_SET_TAGGED_ADDR_CTRL:
>   2647                  if (arg3 || arg4 || arg5)
>   2648                          return -EINVAL;
>   2649                  error =3D SET_TAGGED_ADDR_CTRL(arg2);
>   2650                  break;
>   2651          case PR_GET_TAGGED_ADDR_CTRL:
>   2652                  if (arg2 || arg3 || arg4 || arg5)
>   2653                          return -EINVAL;
>   2654                  error =3D GET_TAGGED_ADDR_CTRL();
>   2655                  break;
>   2656          case PR_SET_IO_FLUSHER:
>   2657                  if (!capable(CAP_SYS_RESOURCE))
>   2658                          return -EPERM;
>   2659
>   2660                  if (arg3 || arg4 || arg5)
>   2661                          return -EINVAL;
>   2662
>   2663                  if (arg2 =3D=3D 1)
>   2664                          current->flags |=3D PR_IO_FLUSHER;
>   2665                  else if (!arg2)
>   2666                          current->flags &=3D ~PR_IO_FLUSHER;
>   2667                  else
>   2668                          return -EINVAL;
>   2669                  break;
>   2670          case PR_GET_IO_FLUSHER:
>   2671                  if (!capable(CAP_SYS_RESOURCE))
>   2672                          return -EPERM;
>   2673
>   2674                  if (arg2 || arg3 || arg4 || arg5)
>   2675                          return -EINVAL;
>   2676
>   2677                  error =3D (current->flags & PR_IO_FLUSHER) =3D=3D=
 PR_IO_FLUSHER;
>   2678                  break;
>   2679          case PR_SET_SYSCALL_USER_DISPATCH:
>   2680                  error =3D set_syscall_user_dispatch(arg2, arg3, a=
rg4,
>   2681                                                    (char __user *)=
 arg5);
>   2682                  break;
>   2683  #ifdef CONFIG_SCHED_CORE
>   2684          case PR_SCHED_CORE:
>   2685                  error =3D sched_core_share_pid(arg2, arg3, arg4, =
arg5);
>   2686                  break;
>   2687  #endif
>   2688          case PR_SET_MDWE:
>   2689                  error =3D prctl_set_mdwe(arg2, arg3, arg4, arg5);
>   2690                  break;
>   2691          case PR_GET_MDWE:
>   2692                  error =3D prctl_get_mdwe(arg2, arg3, arg4, arg5);
>   2693                  break;
>   2694          case PR_SET_VMA:
>   2695                  error =3D prctl_set_vma(arg2, arg3, arg4, arg5);
>   2696                  break;
>   2697  #ifdef CONFIG_KSM
>   2698          case PR_SET_MEMORY_MERGE:
>   2699                  if (arg3 || arg4 || arg5)
>   2700                          return -EINVAL;
>   2701                  if (mmap_write_lock_killable(me->mm))
>   2702                          return -EINTR;
>   2703
>   2704                  if (arg2)
>   2705                          error =3D ksm_enable_merge_any(me->mm);
>   2706                  else
>   2707                          error =3D ksm_disable_merge_any(me->mm);
>   2708                  mmap_write_unlock(me->mm);
>   2709                  break;
>   2710          case PR_GET_MEMORY_MERGE:
>   2711                  if (arg2 || arg3 || arg4 || arg5)
>   2712                          return -EINVAL;
>   2713
>   2714                  error =3D !!test_bit(MMF_VM_MERGE_ANY, &me->mm->f=
lags);
>   2715                  break;
>   2716  #endif
>   2717          case PR_RISCV_V_SET_CONTROL:
> > 2718                  error =3D RISCV_V_SET_CONTROL(arg2);
>   2719                  break;
>   2720          case PR_RISCV_V_GET_CONTROL:
> > 2721                  error =3D RISCV_V_GET_CONTROL();
>   2722                  break;
>   2723          default:
>   2724                  error =3D -EINVAL;
>   2725                  break;
>   2726          }
>   2727          return error;
>   2728  }
>   2729
>
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki

This is the case that Bj=C3=B6rn mentioned in v19[1] but I was too careless
to address it fully. I am going to repsin v21 and solve it (including
the else-clause in processor.h).

[1]: https://lore.kernel.org/all/87ttwdhljn.fsf@all.your.base.are.belong.to=
.us/

Thanks,
Andy
