Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FE7FB82A6
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2019 22:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390003AbfISUjU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Sep 2019 16:39:20 -0400
Received: from mga12.intel.com ([192.55.52.136]:4976 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388901AbfISUjU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Sep 2019 16:39:20 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Sep 2019 13:39:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,526,1559545200"; 
   d="scan'208";a="362639920"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga005.jf.intel.com with ESMTP; 19 Sep 2019 13:39:19 -0700
Date:   Thu, 19 Sep 2019 13:39:19 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Bill Wendling <morbo@google.com>
Cc:     kvm@vger.kernel.org, jmattson@google.com
Subject: Re: [kvm-unit-tests PATCH] x86: setjmp: check expected value of "i"
 to give better feedback
Message-ID: <20190919203919.GF30495@linux.intel.com>
References: <20190911023142.85970-1-morbo@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190911023142.85970-1-morbo@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 10, 2019 at 07:31:42PM -0700, Bill Wendling wrote:
> Use a list of expected values instead of printing out numbers, which
> aren't very meaningful. This prints only if the expected and actual
> values differ.
> 
> Signed-off-by: Bill Wendling <morbo@google.com>
> ---
>  x86/setjmp.c | 19 +++++++++++++++----
>  1 file changed, 15 insertions(+), 4 deletions(-)
> 
> diff --git a/x86/setjmp.c b/x86/setjmp.c
> index 976a632..c0b25ec 100644
> --- a/x86/setjmp.c
> +++ b/x86/setjmp.c
> @@ -1,19 +1,30 @@
>  #include "libcflat.h"
>  #include "setjmp.h"
>  
> +int expected[] = {

This should be 'static const'.

> +	0, 1, 2, 3, 4, 5, 6, 7, 8, 9
> +};
> +
> +#define NUM_EXPECTED (sizeof(expected) / sizeof(int))

How about NUM_LONGJMPS?  And you can use ARRAY_SIZE.

> +
>  int main(void)
>  {
> -    volatile int i;
> +    volatile int i = -1, index = 0;
> +    volatile bool had_errors = false;
>      jmp_buf j;
>  
>      if (setjmp(j) == 0) {
>  	    i = 0;
>      }
> -    printf("%d\n", i);
> -    if (++i < 10) {
> +    if (expected[index++] != i) {
> +	    printf("FAIL: actual %d / expected %d\n", i, expected[index]);

This will print the wrong expected value on failure since index was
incremented above.

> +            had_errors = true;
> +    }

had_errors seems like overkill.  If we fail once, what's the pointing of
continuing on? 

> +    if (index < NUM_EXPECTED) {
> +	    i++;
>  	    longjmp(j, 1);
>      }

And we should pass i to longjmp(), otherwise there isn't really any point
to having separate index and i variables, e.g.:

	volatile int index = 0;
	jmp_buf j;
	int i;

	i = setjmp(j);

	if (expected[index] != i) {
		printf("FAIL: actual %d / expected %d\n", i, expected[index]);
		return -1;
	}
	index++;

	if (i < NUM_LONGJMPS)
		longjmp(jmp_buf, i + 1);	

	return 0;

>  
> -    printf("done\n");
> +    printf("Test %s\n", had_errors ? "FAILED" : "PASSED");
>      return 0;
>  }
> -- 
> 2.23.0.162.g0b9fbb3734-goog
> 
