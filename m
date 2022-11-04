Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F00261A223
	for <lists+kvm@lfdr.de>; Fri,  4 Nov 2022 21:27:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230011AbiKDU1g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Nov 2022 16:27:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230007AbiKDU1d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Nov 2022 16:27:33 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7B904D5C7
        for <kvm@vger.kernel.org>; Fri,  4 Nov 2022 13:27:32 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id k15so5469896pfg.2
        for <kvm@vger.kernel.org>; Fri, 04 Nov 2022 13:27:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ks9HP5ulYF6yOWN9F2eqsMKBJB5JnoP2doi07Oo/x2s=;
        b=YAlNsBYMPX1cssU4+etS5cMkN7hU6svBONJPWZ/YzYn88Kju1bE18kTFihJJjT9+gp
         h+Tj2BQCtPBvvxZjZhI3YEuupWvxAMjVDRyiuD/YnmXytROOGPyC7qEZgtxBQbXrglOR
         e8y+oAr/zU5kO8pUqsh+MmJ6CRSqILjic8T3ueOHxSUoRqWClv48O0b3sWtAc+tJ+wOu
         eVDHW9WGzVd2ZJDAkixgvsI7J2uUiQRg5S3PCrzc7TS8NEOJF8HILMAWLvP4LV7VX75D
         YDTNPE3KcJ5+QJLV9IwHQTZ+NbzbHAF/wmBQx6Qw4YUa+Su7ZDJPH2Ies8hjLylG9njR
         rYxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ks9HP5ulYF6yOWN9F2eqsMKBJB5JnoP2doi07Oo/x2s=;
        b=8R4MCUXDggW7/EnScJO+xzWooNRvT5GXnWezealxrplGEP8W2T1N60WMCyTaJcYwV6
         djsjY5DHGUY1NpcalOhKpDvedhu0ET7HDNRTNw9GwXWYOVoLCa4YGmeOvx+4yvnByjj1
         7lBlZjWQr281Sb0oVUyKQL464+a0XmkkpWOwsUCMFBvaSNDiianwuDFbIDmEXzq8p3SY
         2cQww1mYYwdx4bJhpVbRwpc+9jaBjAV+TNzKnL9lrcKsU7m/nUIJf+xFzjWHdoxayqPx
         mGSt7BxSkw9wo0R73+79/Q5MSCVmxLYOEW615ZE7YVWkeJOJngyoQP5F9vKQvhX2LfcJ
         gVgA==
X-Gm-Message-State: ACrzQf0jqINoNIAGBVjRri2tPa7PIPMRwpwRwMXr6XHK/APuEF8JjQga
        eOYXfo+Ht0tFBdBcY0HvfLlqng==
X-Google-Smtp-Source: AMsMyM7RxIb2Gf58yQXfe4YEZB+VBD5LgJ/hJqED1dL9jUd1+fbtbOp74dCMoPE5orfOqFiHqzon5w==
X-Received: by 2002:a63:f214:0:b0:461:8862:331e with SMTP id v20-20020a63f214000000b004618862331emr31614615pgh.386.1667593652140;
        Fri, 04 Nov 2022 13:27:32 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id y6-20020a633206000000b00439c6a4e1ccsm124696pgy.62.2022.11.04.13.27.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Nov 2022 13:27:31 -0700 (PDT)
Date:   Fri, 4 Nov 2022 20:27:28 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Gavin Shan <gshan@redhat.com>
Cc:     Robert Hoo <robert.hu@linux.intel.com>, pbonzini@redhat.com,
        kvm@vger.kernel.org
Subject: Re: [RFC 1/1] KVM: selftests: rseq_test: use vdso_getcpu() instead
 of syscall()
Message-ID: <Y2V1sFwqMR36Yq/H@google.com>
References: <20221102020128.3030511-1-robert.hu@linux.intel.com>
 <20221102020128.3030511-2-robert.hu@linux.intel.com>
 <Y2MPe3qhgQG0euE0@google.com>
 <b7ae920f-dae0-b3f3-aba3-944cb73c19c2@redhat.com>
 <Y2RzdQVvZnS7wcMr@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y2RzdQVvZnS7wcMr@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 04, 2022, Sean Christopherson wrote:
> On Thu, Nov 03, 2022, Gavin Shan wrote:
> > On 11/3/22 8:46 AM, Sean Christopherson wrote:
> > > On Wed, Nov 02, 2022, Robert Hoo wrote:
> > > > @@ -253,7 +269,7 @@ int main(int argc, char *argv[])
> > > >   			 * across the seq_cnt reads.
> > > >   			 */
> > > >   			smp_rmb();
> > > > -			sys_getcpu(&cpu);
> > > > +			vdso_getcpu(&cpu, NULL, NULL);
> > > >   			rseq_cpu = rseq_current_cpu_raw();
> > > >   			smp_rmb();
> > > >   		} while (snapshot != atomic_read(&seq_cnt));
> > > 
> > > Something seems off here.  Half of the iterations in the migration thread have a
> > > delay of 5+us, which should be more than enough time to complete a few getcpu()
> > > syscalls to stabilize the CPU.
> > > 
> > > Has anyone tried to figure out why the vCPU thread is apparently running slow?
> > > E.g. is KVM_RUN itself taking a long time, is the task not getting scheduled in,
> > > etc...  I can see how using vDSO would make the vCPU more efficient, but I'm
> > > curious as to why that's a problem in the first place.
> > > 
> > > Anyways, assuming there's no underlying problem that can be solved, the easier
> > > solution is to just bump the delay in the migration thread.  As per its gigantic
> > > comment, the original bug reproduced with up to 500us delays, so bumping the min
> > > delay to e.g. 5us is acceptable.  If that doesn't guarantee the vCPU meets its
> > > quota, then something else is definitely going on.
> > > 
> > 
> > I doubt if it's still caused by busy system as mentioned previously [1]. At least,
> > I failed to reproduce the issue on my ARM64 system until some workloads are enforced
> > to hog CPUs.
> 
> Yeah, I suspect something else as well.  My best guest at this point is mitigations,
> I'll test that tomorrow to see if it makes any difference.

So much for the mitigations theory, the migration thread gets slowed down more than
the vCPU thread.
